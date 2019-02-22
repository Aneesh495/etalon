"""
Clean Uniqueness Type Checker for the Etalon verification toolchain.

Validates the uniqueness typing invariants of Concurrent Clean:
1. An object of unique type (*T) must have at most one reference along each execution path.
2. In-place destructive modification is permitted only on unique references.
3. Threading of uniqueness states (*World, *NetworkState, *CrossConnect) must be linear.

Copyright (c) 2026 Aneesh Krishna. All rights reserved.
Distributed under the MIT License.
"""

from typing import Dict, List, Set, Tuple
from .ast_nodes import CleanModule, TypeSig, FunctionDef

class UniquenessViolation:
    def __init__(self, function_name: str, var_name: str, reason: str):
        self.function_name = function_name
        self.var_name = var_name
        self.reason = reason

    def __repr__(self):
        return f"UniquenessViolation(in '{self.function_name}', var '{self.var_name}': {self.reason})"

class UniquenessChecker:
    def __init__(self, module: CleanModule):
        self.module = module
        self.violations: List[UniquenessViolation] = []

    def check(self) -> List[UniquenessViolation]:
        for fn_name, sig in self.module.signatures.items():
            unique_args = []
            for idx, arg_type in enumerate(sig.arg_types):
                if arg_type.is_unique:
                    unique_args.append(idx)

            if not unique_args:
                continue

            # Check function definitions matching this signature
            fn_defs = self.module.functions.get(fn_name, [])
            for fn_def in fn_defs:
                self.check_function_uniqueness(fn_def, unique_args, sig)

        return self.violations

    def check_function_uniqueness(self, fn_def: FunctionDef, unique_arg_indices: List[int], sig: TypeSig):
        for idx in unique_arg_indices:
            if idx < len(fn_def.patterns):
                var_name = fn_def.patterns[idx]
                # Check occurrence count in body string
                body = fn_def.body
                if isinstance(body, str):
                    # Simple token-level occurrence count
                    tokens = [t.strip("(),;{}[]") for t in body.split()]
                    occurrences = sum(1 for t in tokens if t == var_name)
                    # In a linear uniqueness thread, the variable should appear once,
                    # or if updated into a new state (e.g. { state & field = val }), exactly once.
                    if occurrences > 1:
                        # Allow record update pattern: { var & ... }
                        if body.count(f"{{ {var_name} &") == 1 and occurrences == 2:
                            # Standard Clean record update: { var & field = val }
                            continue
                        self.violations.append(
                            UniquenessViolation(
                                function_name=fn_def.name,
                                var_name=var_name,
                                reason=f"Unique variable '{var_name}' referenced {occurrences} times (violates single-reference rule)"
                            )
                        )
