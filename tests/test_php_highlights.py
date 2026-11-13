"""Regression cases for PHP captures. Uses the Python tree-sitter and tree-sitter-php packages."""
from pathlib import Path
import unittest

import tree_sitter_php
from tree_sitter import Language, Parser, Query, QueryCursor


class PhpHighlightsTest(unittest.TestCase):
    def test_overlapping_roles(self):
        php = Language(tree_sitter_php.language_php())
        parser = Parser(php)
        highlights = Path(__file__).resolve().parents[1] / "languages/php/highlights.scm"
        query = Query(php, highlights.read_text())
        cases = [
            ("$Runner = new Runner();", [("$Runner", "variable"), ("new ", "keyword"), ("Runner", "type")]),
            ("use Gui\\Classes\\Runner;", [("Gui", "namespace"), ("Classes", "namespace"), ("Runner", "type")]),
            ("$Runner->Run;", [("$Runner", "variable"), ("Run", "property")]),
            ("echo __DIR__, null;", [("__DIR__", "constant"), ("null", "constant.builtin")]),
            ("Environment::init($CheckCron);", [("Environment", "type"), ("init", "function.method.static"), ("$CheckCron", "variable")]),
            ("use Foo\\{Bar, function RUN, const X};", [("Bar", "type"), ("RUN", "function"), ("X", "constant")]),
            ("new Acme\\HTTP();", [("Acme", "namespace"), ("HTTP", "type")]),
            ("A::$Field; $o->$Field;", [("$Field", "property.static"), ("$Field", "variable")]),
            ("if (isset($V)) {}", [("isset", "keyword"), ("$V", "variable")]),
        ]
        for snippet, checks in cases:
            with self.subTest(snippet=snippet):
                source = ("<?php " + snippet).encode()
                root = parser.parse(source).root_node
                self.assertFalse(root.has_error)
                matches = QueryCursor(query).matches(root)
                start = 0
                for token, style in checks:
                    start = source.index(token.encode(), start)
                    for offset in range(start, start + len(token.rstrip())):
                        covering = [
                            (node.start_byte, -node.end_byte, pattern, capture)
                            for pattern, captures in matches
                            for capture, nodes in captures.items()
                            for node in nodes if node.start_byte <= offset < node.end_byte
                        ]
                        self.assertTrue(covering, token)
                        self.assertEqual(max(covering)[-1], style, token)
                    start += len(token)


if __name__ == "__main__":
    unittest.main()
