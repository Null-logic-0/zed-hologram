; Auto-indentation.
;
; @indent marks a node whose contents sit one level in. @start and @end move
; the ends of that range, so the lines carrying the delimiters themselves
; stay at the outer level. @outdent closes the innermost range early.

; While a start tag is still open, its attributes indent.
(start_tag
  ">" @end) @indent

(self_closing_tag
  "/>" @end) @indent

(void_element
  [
    ">"
    "/>"
  ] @end) @indent

; Children of an element indent. The end tag is optional so indentation
; still works while you are typing and have not closed the element yet.
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

; Children of a control-flow block indent the same way.
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

; {%else} returns to the block's own level, then its children indent again.
(else_directive) @outdent

(else_branch) @indent
