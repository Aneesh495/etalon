"""
Concurrent Clean Parser for the Etalon verification toolchain.
Parses Definition (.dcl) and Implementation (.icl) Clean modules.

Copyright (c) 2026 Aneesh Krishna. All rights reserved.
Distributed under the MIT License.
"""

from typing import List, Optional
from .lexer import Token, tokenize
from .ast_nodes import (
    CleanModule, TypeExpr, RecordDecl, RecordField,
    AlgTypeDecl, ConstructorDecl, TypeSig, FunctionDef
)

class Parser:
    def __init__(self, tokens: List[Token]):
        self.tokens = tokens
        self.pos = 0

    def peek(self, offset: int = 0) -> Optional[Token]:
        idx = self.pos + offset
        if idx < len(self.tokens):
            return self.tokens[idx]
        return None

    def match(self, kind: str, value: Optional[str] = None) -> bool:
        tok = self.peek()
        if not tok:
            return False
        if tok.kind != kind:
            return False
        if value is not None and tok.value != value:
            return False
        self.pos += 1
        return True

    def expect(self, kind: str, value: Optional[str] = None) -> Token:
        tok = self.peek()
        if not tok:
            raise SyntaxError(f"Unexpected EOF, expected {kind} {value or ''}")
        if tok.kind != kind or (value is not None and tok.value != value):
            raise SyntaxError(f"Line {tok.line}:{tok.col}: expected {kind} {value or ''}, got {tok.kind} {tok.value}")
        self.pos += 1
        return tok

    def parse_module(self) -> CleanModule:
        # Check module header: [implementation | definition] module ModuleName
        is_def = False
        tok = self.peek()
        if tok and tok.kind == "KEYWORD" and tok.value in ("implementation", "definition"):
            is_def = (tok.value == "definition")
            self.pos += 1

        self.expect("KEYWORD", "module")
        mod_name_tok = self.expect("IDENT")
        mod_name = mod_name_tok.value
        # Allow multi-segment module names like Etalon.Types.Base
        while self.match("DOT"):
            next_seg = self.expect("IDENT")
            mod_name += "." + next_seg.value

        module = CleanModule(is_definition=is_def, name=mod_name)

        # Parse declarations until EOF
        while self.pos < len(self.tokens):
            tok = self.peek()
            if not tok:
                break

            # Import declaration: import X or from X import Y
            if tok.kind == "KEYWORD" and tok.value in ("import", "from"):
                self.parse_import(module)
                continue

            # Type or record declaration: :: ...
            if tok.kind == "DCOLON":
                self.parse_type_or_record_decl(module)
                continue

            # Constant macro definition: name :== val
            if tok.kind in ("IDENT", "OP"):
                next_tok = self.peek(1)
                if next_tok and next_tok.kind == "MACRO_DEF":
                    self.pos += 2  # consume name and :==
                    # consume remainder of macro expression on same line
                    while self.pos < len(self.tokens):
                        t = self.peek()
                        if not t or (t.col == 1 and t.kind in ("IDENT", "DCOLON", "KEYWORD")):
                            break
                        self.pos += 1
                    continue
                elif next_tok and next_tok.kind == "DCOLON":
                    sig = self.parse_signature()
                    module.signatures[sig.name] = sig
                else:
                    fn = self.parse_function_def()
                    if fn.name not in module.functions:
                        module.functions[fn.name] = []
                    module.functions[fn.name].append(fn)
                continue

            # Fallback consume token
            self.pos += 1

        return module

    def parse_import(self, module: CleanModule):
        tok = self.peek()
        if tok and tok.value == "import":
            self.pos += 1
            while self.pos < len(self.tokens):
                id_tok = self.expect("IDENT")
                name = id_tok.value
                while self.match("DOT"):
                    name += "." + self.expect("IDENT").value
                module.imports.append(name)
                if not self.match("COMMA"):
                    break
        elif tok and tok.value == "from":
            self.pos += 1
            mod_tok = self.expect("IDENT")
            name = mod_tok.value
            while self.match("DOT"):
                name += "." + self.expect("IDENT").value
            self.expect("KEYWORD", "import")
            # Consume imported symbols until end of line / next decl
            while self.pos < len(self.tokens):
                t = self.peek()
                if not t or t.kind in ("DCOLON", "KEYWORD"):
                    break
                self.pos += 1

    def parse_type_expr(self) -> TypeExpr:
        is_unique = False
        is_strict = False

        while True:
            if self.match("STAR"):
                is_unique = True
            elif self.match("BANG"):
                is_strict = True
            elif self.match("DOT"):
                pass
            else:
                break
        
        tok = self.peek()
        if not tok:
            raise SyntaxError("Unexpected EOF while parsing type expression")

        if tok.kind == "LPAREN":
            self.pos += 1
            # Could be tuple type or nested type
            sub_types = []
            while not self.match("RPAREN"):
                sub_types.append(self.parse_type_expr())
                if self.match("COMMA"):
                    continue
            name = "Tuple" if len(sub_types) > 1 else (sub_types[0].name if sub_types else "()")
            return TypeExpr(name=name, is_unique=is_unique, is_strict=is_strict, args=sub_types)

        if tok.kind == "LBRACKET":
            self.pos += 1
            elem_type = self.parse_type_expr()
            self.expect("RBRACKET")
            return TypeExpr(name="List", is_unique=is_unique, is_strict=is_strict, args=[elem_type])

        tok = self.expect("IDENT")
        name = tok.value
        # Check if type has type parameters on the SAME LINE (e.g. Maybe a)
        args = []
        while self.pos < len(self.tokens):
            next_t = self.peek()
            if next_t and next_t.line == tok.line and next_t.kind == "IDENT" and next_t.value[0].islower():
                args.append(TypeExpr(name=next_t.value))
                self.pos += 1
            else:
                break

        return TypeExpr(name=name, is_unique=is_unique, is_strict=is_strict, args=args)

    def parse_type_or_record_decl(self, module: CleanModule):
        self.expect("DCOLON")
        is_unique = self.match("STAR")
        name_tok = self.expect("IDENT")
        type_name = name_tok.value

        # Optional type arguments (e.g. :: *Tree a)
        while self.pos < len(self.tokens):
            t = self.peek()
            if t and t.kind == "IDENT" and t.value[0].islower():
                self.pos += 1
            else:
                break

        self.expect("EQ")

        # Check if record declaration { ... }
        if self.match("LBRACE"):
            fields = []
            while not self.match("RBRACE") and self.pos < len(self.tokens):
                fname = self.expect("IDENT").value
                self.expect("DCOLON")
                ftype = self.parse_type_expr()
                fields.append(RecordField(name=fname, field_type=ftype))
                self.match("COMMA")
            rec = RecordDecl(name=type_name, is_unique=is_unique, fields=fields)
            module.records[type_name] = rec
        else:
            # Algebraic data type: Cons1 | Cons2 arg | ...
            constructors = []
            while self.pos < len(self.tokens):
                cname_tok = self.expect("IDENT")
                cname = cname_tok.value
                cons_line = cname_tok.line
                cargs = []
                while self.pos < len(self.tokens):
                    t = self.peek()
                    if t and t.col > 1 and t.kind in ("IDENT", "BANG", "STAR", "LPAREN", "LBRACKET") and t.value not in ("|", ";"):
                        if t.kind == "KEYWORD":
                            break
                        # In Clean, constructor arguments must not be another constructor on a new line
                        if t.line != cons_line and self.peek(1) and self.peek(1).value == "=":
                            break
                        cargs.append(self.parse_type_expr())
                    else:
                        break
                constructors.append(ConstructorDecl(name=cname, args=cargs))
                if not self.match("BAR"):
                    break
            alg = AlgTypeDecl(name=type_name, is_unique=is_unique, constructors=constructors)
            module.types[type_name] = alg

    def parse_signature(self) -> TypeSig:
        fname = self.expect("IDENT").value
        self.expect("DCOLON")
        arg_types = []
        return_type = None

        while self.pos < len(self.tokens):
            t = self.peek()
            if not t or (t.col == 1 and t.kind in ("DCOLON", "KEYWORD")):
                break
            if self.match("ARROW"):
                return_type = self.parse_type_expr()
                break
            arg_types.append(self.parse_type_expr())

        if return_type is None:
            if len(arg_types) > 1:
                return_type = arg_types[-1]
                arg_types = arg_types[:-1]
            elif len(arg_types) == 1:
                return_type = arg_types[0]
                arg_types = []
            else:
                return_type = TypeExpr(name="Void")

        return TypeSig(name=fname, arg_types=arg_types, return_type=return_type)

    def parse_function_def(self) -> FunctionDef:
        fname_tok = self.peek()
        fname = fname_tok.value
        self.pos += 1

        patterns = []
        while self.pos < len(self.tokens):
            t = self.peek()
            if not t or t.kind in ("EQ", "BAR", "ARROW", "DCOLON"):
                break
            patterns.append(t.value)
            self.pos += 1

        # Check guards or direct = body
        body_tokens = []
        while self.pos < len(self.tokens):
            t = self.peek()
            if not t:
                break
            # End of function definition when next line starts a new def/sig/decl
            if t.col == 1 and t.kind in ("DCOLON", "KEYWORD"):
                break
            if t.col == 1 and len(body_tokens) > 0 and t.kind == "IDENT":
                # Possible next function definition or clause
                break
            body_tokens.append(t.value)
            self.pos += 1

        body_str = " ".join(body_tokens)
        return FunctionDef(name=fname, patterns=patterns, body=body_str)

def parse_clean_source(source: str) -> CleanModule:
    tokens = tokenize(source)
    parser = Parser(tokens)
    return parser.parse_module()
