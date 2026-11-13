(document) @comment.doc

(tag_name) @comment.doc.tag

(tag
  (variable_name) @variable)

(variable_name
  "$" @variable)

(tag
  (tag_name) @keyword
  (#eq? @keyword "@method")
  (name) @function.method)

(primitive_type) @type.builtin

(named_type
  (name) @type) @type

(named_type
  (qualified_name) @type) @type
