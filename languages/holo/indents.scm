; @indent marks a node whose contents sit one level in.
; @start and @end shrink that range so the delimiter lines stay put.
; @outdent closes the innermost range early.

; Attributes indent while a start tag is still open.
(start_tag
  ">" @end) @indent

(self_closing_tag
  "/>" @end) @indent

(void_element
  [
    ">"
    "/>"
  ] @end) @indent

; Element children. The end tag is optional so this works while typing.
[
  (element
    (start_tag) @start
    (end_tag)? @end)
  (script_element
    (start_tag) @start
    (end_tag)? @end)
  (style_element
    (start_tag) @start
    (end_tag)? @end)
] @indent

[
  (if_block
    (if_open) @start
    (if_close)? @end)
  (for_block
    (for_open) @start
    (for_close)? @end)
  (raw_block
    (raw_open) @start
    (raw_close)? @end)
] @indent

; Pull {%else} back to the block's level, then indent its children again.
(else_directive) @outdent

(else_branch) @indent
