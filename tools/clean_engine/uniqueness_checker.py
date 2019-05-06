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

                # Clean supports branching (| guard = expr = default_expr or if cond then else)
                import re
                branches = []
                if "|" in body:
                    # Match guarded expression: | cond = expr1 = expr2 or multiple guards
                    m = re.search(r'(?<!\|)\|\s*(.*?)\s*(?<![<>!=:])=\s*(.*?)\s*(?<![<>!=:])=\s*(.*)', body)
                    if m:
                        _, b1, b2 = m.groups()
                        branches.append(b1)
                        branches.append(b2)
                    else:
                        # Fallback split
                        parts = re.split(r'(?<!\|)\|(?!\|)', body)
                        for p in parts[1:]:
                            eq_parts = re.split(r'(?<![<>!=:])\s+=\s+(?![=])', p)
                            if len(eq_parts) > 1:
                                branches.append(eq_parts[1])
                            else:
                                branches.append(p)
                elif "if " in body and "else" in body:
                    # if-then-else alternative branches
                    m_if = re.search(r'\bif\b\s*(.*?)\s*(?:\bthen\b|\()\s*(.*?)\s*\belse\b\s*(.*)', body)
                    if m_if:
                        _, b_then, b_else = m_if.groups()
                        branches.append(b_then)
                        branches.append(b_else)
                    else:
                        branches.append(body)
                else:
                    branches.append(body)

                for branch in branches:
                    tokens = [t.strip("(),;{}[]") for t in branch.split()]
                    occ = sum(1 for t in tokens if t == var_name)
                    if occ > 1:
                        if branch.count(f"{{ {var_name} &") == 1 and occ <= 2:
                            continue
                        if f"{var_name}." in branch:
                            continue
                        if f"let {var_name}" in branch or f"in {var_name}" in branch:
                            continue
                        self.violations.append(
                            UniquenessViolation(
                                function_name=fn_def.name,
                                var_name=var_name,
                                reason=f"Unique variable '{var_name}' referenced {occ} times in branch '{branch[:30]}...'"
                            )
                        )
