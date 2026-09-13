; Step 5 smoke test: proves the compiled grammar, including the new block
; nodes, is live inside Zed. Step 6 replaces this with the real query.
(tag_name) @tag
(component_name) @tag

["{%if" "{%for"] @keyword
[(else_directive) (if_close) (for_close) (raw_open) (raw_close)] @keyword
(raw_text) @string
