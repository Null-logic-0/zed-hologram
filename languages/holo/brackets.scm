; Bracket matching, auto-closing, and the highlight shown when the cursor
; sits on one half of a pair.
;
; newline.only marks a pair that should only affect what happens when you
; press Return between the two halves, not bracket highlighting.
; rainbow.exclude keeps tags out of rainbow bracket colouring, which would
; otherwise make ordinary markup very noisy.

((start_tag
  "<" @open
  ">" @close)
  (#set! rainbow.exclude))

((self_closing_tag
  "<" @open
  "/>" @close)
  (#set! rainbow.exclude))

((end_tag
  "</" @open
  ">" @close)
  (#set! rainbow.exclude))

((void_element
  "<" @open
  [
    ">"
    "/>"
  ] @close)
  (#set! rainbow.exclude))

((element
  (start_tag) @open
  (end_tag) @close)
  (#set! newline.only)
  (#set! rainbow.exclude))

((script_element
  (start_tag) @open
  (end_tag) @close)
  (#set! newline.only)
  (#set! rainbow.exclude))

((style_element
  (start_tag) @open
  (end_tag) @close)
  (#set! newline.only)
  (#set! rainbow.exclude))

; Expression braces are a real pair worth highlighting.
(expression
  "{" @open
  "}" @close)

; Block open and close tags pair up like tags do.
((if_block
  (if_open) @open
  (if_close) @close)
  (#set! newline.only))

((for_block
  (for_open) @open
  (for_close) @close)
  (#set! newline.only))

((raw_block
  (raw_open) @open
  (raw_close) @close)
  (#set! newline.only))

((comment
  "<!--" @open
  "-->" @close)
  (#set! rainbow.exclude))
