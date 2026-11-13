; In expression position, a bare PHP name is a constant reference.
(primary_expression/name) @constant
(primary_expression/qualified_name (name) @constant)
(primary_expression/relative_name (name) @constant)
(const_element . (name) @constant)
(enum_case name: (name) @constant)

[(php_tag) (php_end_tag)] @keyword

; Variables, including their sigil. A dynamic variable's inner expression
; still receives its own highlights.
(variable_name) @variable
(variable_name "$" @variable (name) @variable)
((variable_name "$" @variable.builtin (name) @variable.builtin.this)
  (#eq? @variable.builtin.this "this"))

; Types and namespaces
[(primitive_type) (cast_type)] @type.builtin
(relative_scope) @keyword
(namespace_name (name) @namespace)

[
  (class_declaration name: (name) @type)
  (interface_declaration name: (name) @type)
  (trait_declaration name: (name) @type)
  (enum_declaration name: (name) @type)
]

[
  (named_type (_) @type)
  (base_clause (_) @type)
  (class_interface_clause (_) @type)
  (use_declaration [(name) (qualified_name) (relative_name)] @type)
  (object_creation_expression [(name) (qualified_name) (relative_name)] @type)
  (binary_expression operator: "instanceof" right: [(name) (qualified_name) (relative_name)] @type)
  (scoped_call_expression scope: [(name) (qualified_name) (relative_name)] @type)
  (scoped_property_access_expression scope: [(name) (qualified_name) (relative_name)] @type)
  (class_constant_access_expression . [(name) (qualified_name) (relative_name)] @type)
]

; A use clause can import a type, a function or a constant. Grouped imports
; may put that keyword on the enclosing declaration.
(namespace_use_clause [(name) (qualified_name)] @type)
(namespace_use_clause type: "function" [(name) (qualified_name)] @function)
(namespace_use_clause type: "const" [(name) (qualified_name)] @constant)
(namespace_use_declaration type: "function"
  body: (namespace_use_group (namespace_use_clause [(name) (qualified_name)] @function)))
(namespace_use_declaration type: "const"
  body: (namespace_use_group (namespace_use_clause [(name) (qualified_name)] @constant)))

; Named arguments
(argument name: (name) @variable.parameter)

; Functions and methods
(array_creation_expression "array" @function.builtin)
(list_literal "list" @function.builtin)
(function_definition name: (name) @function.definition)
(function_call_expression function: [(name) @function.php (qualified_name (name) @function.php) (relative_name (name) @function.php)])
((function_call_expression function: (name) @keyword)
  (#match? @keyword "(?i)^(isset|empty|eval|exit|die)$"))
(method_declaration name: (name) @function.method)
(scoped_call_expression name: (name) @function.method.static)
(member_call_expression name: (name) @function.method)
(nullsafe_member_call_expression name: (name) @function.method)

; Members. In $object->$name the name is itself a variable.
(property_element name: (variable_name "$" @property (name) @property))
(scoped_property_access_expression name: (variable_name "$" @property.static (name) @property.static))
(member_access_expression name: (name) @property)
(nullsafe_member_access_expression name: (name) @property)
(class_constant_access_expression (_) (name) @constant)

; Basic tokens
[
  (string)
  (string_content)
  (encapsed_string)
  (heredoc)
  (heredoc_body)
  (nowdoc_body)
] @string

(boolean) @constant.builtin

(null) @constant.builtin

(integer) @number

(float) @number

(comment) @comment
((comment) @comment.doc
  (#match? @comment.doc "^/\\*\\*"))

; Operators
[
  "="
  "+="
  "-="
  "*="
  "/="
  "%="
  "**="
  ".="
  "??="
  "&="
  "|="
  "^="
  "<<="
  ">>="
  "+"
  "-"
  "*"
  "/"
  "%"
  "**"
  "."
  "=="
  "!="
  "==="
  "!=="
  "<"
  ">"
  "<="
  ">="
  "<=>"
  "&&"
  "||"
  "!"
  "??"
  "?"
  ":"
  "&"
  "|"
  "^"
  "~"
  "<<"
  ">>"
  "++"
  "--"
  "@"
] @operator

(dynamic_variable_name "$" @operator)

; punctuation
[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket

; Keywords
"abstract" @keyword

"and" @keyword

"as" @keyword

"break" @keyword

"case" @keyword

"catch" @keyword

"class" @keyword

"clone" @keyword

"const" @keyword

"continue" @keyword

"declare" @keyword

"default" @keyword

"do" @keyword

"echo" @keyword

"else" @keyword

"elseif" @keyword

"enum" @keyword

"enddeclare" @keyword

"endfor" @keyword

"endforeach" @keyword

"endif" @keyword

"endswitch" @keyword

"endwhile" @keyword

"extends" @keyword

"final" @keyword

"readonly" @keyword

"finally" @keyword

"for" @keyword

"foreach" @keyword

"fn" @keyword

"function" @keyword

"global" @keyword

"goto" @keyword

"if" @keyword

"implements" @keyword

"include_once" @keyword

"include" @keyword

"instanceof" @keyword

"insteadof" @keyword

"interface" @keyword

"match" @keyword

"namespace" @keyword

"new" @keyword

"or" @keyword

"print" @keyword

"private" @keyword

"protected" @keyword

"public" @keyword

"readonly" @keyword

"require_once" @keyword

"require" @keyword

"return" @keyword

"static" @keyword

"switch" @keyword

"throw" @keyword

"trait" @keyword

"try" @keyword

"use" @keyword

"while" @keyword

"xor" @keyword

"yield" @keyword

"yield from" @keyword
