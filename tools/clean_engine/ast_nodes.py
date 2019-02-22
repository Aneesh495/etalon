"""
Abstract Syntax Tree (AST) representations for Concurrent Clean.

Copyright (c) 2026 Aneesh Krishna. All rights reserved.
Distributed under the MIT License.
"""

from typing import List, Dict, Optional, Any

class ASTNode:
    pass

class TypeExpr(ASTNode):
    def __init__(self, name: str, is_unique: bool = False, is_strict: bool = False, args: Optional[List['TypeExpr']] = None):
        self.name = name
        self.is_unique = is_unique
        self.is_strict = is_strict
        self.args = args or []

    def __repr__(self):
        prefix = ("*" if self.is_unique else "") + ("!" if self.is_strict else "")
        if self.args:
            return f"{prefix}{self.name} [{' '.join(repr(a) for a in self.args)}]"
        return f"{prefix}{self.name}"

class RecordField(ASTNode):
    def __init__(self, name: str, field_type: TypeExpr):
        self.name = name
        self.field_type = field_type

    def __repr__(self):
        return f"{self.name} :: {self.field_type}"

class RecordDecl(ASTNode):
    def __init__(self, name: str, is_unique: bool, fields: List[RecordField]):
        self.name = name
        self.is_unique = is_unique
        self.fields = fields

    def __repr__(self):
        prefix = "*" if self.is_unique else ""
        return f":: {prefix}{self.name} = {{ {', '.join(repr(f) for f in self.fields)} }}"

class ConstructorDecl(ASTNode):
    def __init__(self, name: str, args: List[TypeExpr]):
        self.name = name
        self.args = args

    def __repr__(self):
        if self.args:
            return f"{self.name} {' '.join(repr(a) for a in self.args)}"
        return self.name

class AlgTypeDecl(ASTNode):
    def __init__(self, name: str, is_unique: bool, constructors: List[ConstructorDecl]):
        self.name = name
        self.is_unique = is_unique
        self.constructors = constructors

    def __repr__(self):
        prefix = "*" if self.is_unique else ""
        return f":: {prefix}{self.name} = {' | '.join(repr(c) for c in self.constructors)}"

class TypeSynonym(ASTNode):
    def __init__(self, name: str, target: TypeExpr):
        self.name = name
        self.target = target

    def __repr__(self):
        return f":: {self.name} :== {self.target}"

class TypeSig(ASTNode):
    def __init__(self, name: str, arg_types: List[TypeExpr], return_type: TypeExpr):
        self.name = name
        self.arg_types = arg_types
        self.return_type = return_type

    def __repr__(self):
        types = [repr(t) for t in self.arg_types] + [repr(self.return_type)]
        return f"{self.name} :: {' -> '.join(types)}"

class FunctionDef(ASTNode):
    def __init__(self, name: str, patterns: List[str], body: Any, guards: Optional[List[Tuple_Guard]] = None, where_defs: Optional[List['FunctionDef']] = None):
        self.name = name
        self.patterns = patterns
        self.body = body
        self.guards = guards or []
        self.where_defs = where_defs or []

    def __repr__(self):
        return f"{self.name} {' '.join(self.patterns)} = {self.body}"

class Tuple_Guard:
    def __init__(self, condition: str, body: Any):
        self.condition = condition
        self.body = body

class CleanModule(ASTNode):
    def __init__(self, is_definition: bool, name: str):
        self.is_definition = is_definition
        self.name = name
        self.imports: List[str] = []
        self.records: Dict[str, RecordDecl] = {}
        self.types: Dict[str, AlgTypeDecl] = {}
        self.signatures: Dict[str, TypeSig] = {}
        self.functions: Dict[str, List[FunctionDef]] = {}

    def __repr__(self):
        kind = "definition" if self.is_definition else "implementation"
        return f"<CleanModule {kind} {self.name}: {len(self.types)} types, {len(self.records)} records, {len(self.functions)} funcs>"
