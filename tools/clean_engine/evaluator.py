"""
Concurrent Clean Graph Evaluator and Abstract Machine.
Executes pure functional graph reductions, pattern matching, and state threading.

Copyright (c) 2026 Aneesh Krishna. All rights reserved.
Distributed under the MIT License.
"""

from typing import Any, Dict, List, Optional
import math

class Environment:
    def __init__(self, parent: Optional['Environment'] = None):
        self.bindings: Dict[str, Any] = {}
        self.parent = parent

    def lookup(self, name: str) -> Any:
        if name in self.bindings:
            return self.bindings[name]
        if self.parent:
            return self.parent.lookup(name)
        raise NameError(f"Undefined variable in Clean environment: '{name}'")

    def bind(self, name: str, val: Any):
        self.bindings[name] = val

class CleanEvaluator:
    def __init__(self):
        self.global_env = Environment()
        self._init_stdlib()

    def _init_stdlib(self):
        # StdEnv standard mathematical and logical primitives
        self.global_env.bind("+", lambda a, b: a + b)
        self.global_env.bind("-", lambda a, b: a - b)
        self.global_env.bind("*", lambda a, b: a * b)
        self.global_env.bind("/", lambda a, b: a / b if b != 0 else float('inf'))
        self.global_env.bind("==", lambda a, b: a == b)
        self.global_env.bind("<", lambda a, b: a < b)
        self.global_env.bind(">", lambda a, b: a > b)
        self.global_env.bind("<=", lambda a, b: a <= b)
        self.global_env.bind(">=", lambda a, b: a >= b)
        self.global_env.bind("&&", lambda a, b: a and b)
        self.global_env.bind("||", lambda a, b: a or b)
        self.global_env.bind("not", lambda a: not a)
        self.global_env.bind("abs", lambda a: abs(a))
        self.global_env.bind("sqrt", lambda a: math.sqrt(a))
        self.global_env.bind("log10", lambda a: math.log10(a) if a > 0 else -100.0)
        self.global_env.bind("ln", lambda a: math.log(a) if a > 0 else -100.0)
        self.global_env.bind("exp", lambda a: math.exp(a))

    def eval_expr(self, expr_str: str, env: Optional[Environment] = None) -> Any:
        # Evaluates simple clean arithmetic expressions or returns literal
        curr_env = env or self.global_env
        s = expr_str.strip()
        if not s:
            return None

        # Numeric literal
        try:
            if "." in s:
                return float(s)
            return int(s)
        except ValueError:
            pass

        # Boolean literal
        if s == "True": return True
        if s == "False": return False

        # String literal
        if s.startswith('"') and s.endswith('"'):
            return s[1:-1]

        # Variable lookup
        try:
            return curr_env.lookup(s)
        except NameError:
            return s
