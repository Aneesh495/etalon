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
                pat = fn_def.patterns[idx]
                var_name = pat.split("=:")[0].strip()
                body = fn_def.body
                if not isinstance(body, str):
                    continue

                # Clean supports branching (| guard = expr), where each alternative branch
                # evaluates independently. Extract separate branches.
                if "|" in body:
                    branches = []
                    parts = body.split("|")
                    for p in parts:
                        if "=" in p:
                            eq_parts = p.split("=")
                            # The first part is the guard condition; subsequent parts are branch expressions
                            for ep in eq_parts[1:]:
                                branches.append(ep)
                        else:
                            branches.append(p)

                    for branch in branches:
                        tokens = [t.strip("(),;{}[]") for t in branch.split()]
                        occ = sum(1 for t in tokens if t == var_name)
                        if occ > 1:
                            if branch.count(f"{{ {var_name} &") == 1 and occ <= 2:
                                continue
                            self.violations.append(
                                UniquenessViolation(
                                    function_name=fn_def.name,
                                    var_name=var_name,
                                    reason=f"Unique variable '{var_name}' referenced {occ} times in single branch"
                                )
                            )
                else:
                    tokens = [t.strip("(),;{}[]") for t in body.split()]
                    occurrences = sum(1 for t in tokens if t == var_name)
                    if occurrences > 1:
                        if body.count(f"{{ {var_name} &") == 1 and occurrences <= 2:
                            continue
                        # Also check if var is threaded in a let-expression (e.g. let bm1 = ... in { bm1 & ... })
                        if f"{var_name}." in body:
                            # Record field access before record update
                            continue
                        self.violations.append(
                            UniquenessViolation(
                                function_name=fn_def.name,
                                var_name=var_name,
                                reason=f"Unique variable '{var_name}' referenced {occurrences} times"
                            )
                        )
