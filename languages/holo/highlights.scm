; Colours. Zed falls back on dotted names, so @tag.doctype uses "tag" if the
; theme has no "tag.doctype".

(tag_name) @tag

; Components are Elixir modules, so they read as types, not tags.
(component_name) @type

(doctype) @tag.doctype

[
  "<"
  "</"
  ">"
  "/>"
] @punctuation.bracket

(attribute_name) @attribute

; $click and friends are Hologram directives, not HTML attributes.
(event_name) @keyword

(spread "..." @operator)

"=" @punctuation.delimiter

; Quotes and literal text only. Expressions inside are left to the injection.
(quoted_attribute_value "\"" @string)
(attribute_text) @string

; Braces only. The contents are Elixir, coloured by the injection.
(expression
  [
    "{"
    "}"
  ] @punctuation.special)

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

; A raw block's body is literal text.
(raw_text) @string

(comment
  [
    "<!--"
    "-->"
  ] @comment)
(comment_text) @comment

(escape_sequence) @string.escape
