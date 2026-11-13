((text) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined))

((comment) @injection.content
  (#match? @injection.content "^/\\*\\*[^*]")
  (#not-match? @injection.content "^/\\*\\*\\s+@noinspection\\s+[^*\\r\\n]+\\s*\\*/$")
  (#set! injection.language "phpdoc"))

; PHPDoc treats this JetBrains directive as an error. The bundled JSDoc
; grammar recognizes free-form tags in these standalone docblocks.
((comment) @injection.content
  (#match? @injection.content "^/\\*\\*\\s+@noinspection\\s+[^*\\r\\n]+\\s*\\*/$")
  (#set! injection.language "PHP Inspection Doc"))

((comment) @injection.content
  (#not-match? @injection.content "^/\\*\\*")
  (#set! injection.language "comment"))

((heredoc_body)
  (heredoc_end) @injection.language) @injection.content

((nowdoc_body)
  (heredoc_end) @injection.language) @injection.content
