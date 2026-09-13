; Syntax highlighting for HOLO templates.
;
; Capture names are Zed's, and Zed resolves them by longest dotted prefix:
; "@tag.doctype" uses the theme's "tag.doctype" style when it exists and
; falls back to "tag" when it does not. Choices below follow the official
; Hologram VS Code grammar so colours match what Hologram users expect.

; Tags
(tag_name) @tag

; Components are modules, so they are typed like Elixir modules rather than
; like HTML tags. This is what the official grammar and HEEx both do.
(component_name) @type

(doctype) @tag.doctype

[
  "<"
  "</"
  ">"
  "/>"
] @punctuation.bracket

; Attributes
(attribute_name) @attribute

; Event bindings ($click, $change.debounce(300)) are Hologram directives,
; not HTML attributes, so they are keyworded to stand out. Same treatment
; HEEx gives :if and :for.
(event_name) @keyword

(spread "..." @operator)

"=" @punctuation.delimiter

; Quote characters and literal text are strings. Expressions embedded in a
; value are deliberately left alone so the Elixir injection can style them.
(quoted_attribute_value "\"" @string)
(attribute_text) @string

; Expressions
; Only the braces are styled here. The contents are handled by the Elixir
; injection in injections.scm.
(expression
  [
    "{"
    "}"
  ] @punctuation.special)

; Control-flow blocks
[
  "{%if"
  "{%for"
] @keyword

(if_open "}" @keyword)
(for_open "}" @keyword)

[
  (else_directive)
  (if_close)
  (for_close)
  (raw_open)
  (raw_close)
] @keyword

; A raw block's body is literal text, so it reads as a string.
(raw_text) @string

; Comments and escapes
(comment
  [
    "<!--"
    "-->"
  ] @comment)
(comment_text) @comment

(escape_sequence) @string.escape
