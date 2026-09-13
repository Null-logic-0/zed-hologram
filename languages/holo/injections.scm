; Language injections for HOLO templates.
;
; An injection tells Zed to parse a slice of this file with a different
; grammar. That is why this extension never has to describe Elixir,
; JavaScript or CSS itself.

; Every {expression}, plus the conditions of {%if ...} and {%for ...},
; is Elixir. All three use the same expression_value node, so one rule
; covers them.
((expression_value) @injection.content
  (#set! injection.language "elixir"))

; <script> bodies are JavaScript. The body can be several chunks with
; Hologram expressions between them, so the chunks are combined into a
; single virtual document before JavaScript parses them.
(script_element
  (embedded_text) @injection.content
  (#set! injection.language "javascript")
  (#set! injection.combined))

; <style> bodies are CSS, combined for the same reason.
(style_element
  (embedded_text) @injection.content
  (#set! injection.language "css")
  (#set! injection.combined))

; style="..." attribute values are CSS declarations.
(attribute
  (attribute_name) @_attribute_name
  (quoted_attribute_value
    (attribute_text) @injection.content)
  (#eq? @_attribute_name "style")
  (#set! injection.language "css"))
