; Hand slices of the file to other grammars.

; Every {expression}, plus {%if} and {%for} conditions: they share this node.
((expression_value) @injection.content
  (#set! injection.language "elixir"))

; A script body can be several chunks with expressions between them.
; "combined" joins them into one document before JavaScript parses it.
(script_element
  (embedded_text) @injection.content
  (#set! injection.language "javascript")
  (#set! injection.combined))

(style_element
  (embedded_text) @injection.content
  (#set! injection.language "css")
  (#set! injection.combined))

(attribute
  (attribute_name) @_attribute_name
  (quoted_attribute_value
    (attribute_text) @injection.content)
  (#eq? @_attribute_name "style")
  (#set! injection.language "css"))
