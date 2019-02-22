"""
Clean Language Lexer for the Etalon verification toolchain.
Tokenizes Concurrent Clean (.dcl and .icl) source files.

Copyright (c) 2026 Aneesh Krishna. All rights reserved.
Distributed under the MIT License.
"""

import re
from typing import List, Tuple, Optional

TOKEN_SPEC = [
    ("COMMENT_BLOCK", r"/\*[\s\S]*?\*/"),
    ("COMMENT_LINE",  r"//.*"),
    ("STRING",        r'"(?:\\.|[^"\\])*"'),
    ("CHAR",          r"'(?:\\.|[^'\\])'"),
    ("REAL",          r"[-+]?[0-9]+\.[0-9]+([eE][-+]?[0-9]+)?"),
    ("HEX",           r"0x[0-9a-fA-F]+"),
    ("INT",           r"[-+]?[0-9]+"),
    ("ARROW",         r"->"),
    ("DARROW",        r"=>"),
    ("DCOLON",        r"::"),
    ("BAR",           r"\|"),
    ("EQ",            r"="),
    ("BACKSLASH",     r"\\"),
    ("AMP",           r"&"),
    ("STAR",          r"\*"),
    ("BANG",          r"!"),
    ("LPAREN",        r"\("),
    ("RPAREN",        r"\)"),
    ("LBRACKET",      r"\["),
    ("RBRACKET",      r"\]"),
    ("LBRACE",        r"\{"),
    ("RBRACE",        r"\}"),
    ("COMMA",         r","),
    ("SEMICOLON",     r";"),
    ("DOT",           r"\."),
    ("KEYWORD",       r"\b(module|implementation|definition|import|from|class|instance|where|let|in|case|of|if|then|else)\b"),
    ("IDENT",         r"[a-zA-Z_][a-zA-Z0-9_]*"),
    ("OP",            r"[\+\-\*/<>~@#\$%\^&]+"),
    ("WS",            r"[ \t\r\n]+"),
]

TOKEN_RE = re.compile("|".join(f"(?P<{name}>{pattern})" for name, pattern in TOKEN_SPEC))

class Token:
    def __init__(self, kind: str, value: str, line: int, col: int):
        self.kind = kind
        self.value = value
        self.line = line
        self.col = col

    def __repr__(self):
        return f"Token({self.kind}, {self.value!r}, line={self.line}, col={self.col})"

def tokenize(source: str) -> List[Token]:
    tokens = []
    line_num = 1
    line_start = 0

    for match in TOKEN_RE.finditer(source):
        kind = match.lastgroup
        value = match.group(kind)
        start_pos = match.start()
        col = start_pos - line_start + 1

        if kind in ("COMMENT_LINE", "COMMENT_BLOCK", "WS"):
            newlines = value.count("\n")
            if newlines > 0:
                line_num += newlines
                line_start = match.end() - (len(value) - value.rfind("\n") - 1)
            continue

        tokens.append(Token(kind, value, line_num, col))

    return tokens
