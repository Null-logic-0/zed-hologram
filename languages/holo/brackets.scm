; Matching pairs, for highlighting and auto-close.
; newline.only = only affects pressing Return between the halves.
; rainbow.exclude = keep tags out of rainbow bracket colouring.

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

(expression
  "{" @open
  "}" @close)

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
