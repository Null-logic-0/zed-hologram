; Named regions that other settings can refer to.
;
; The bracket rules in config.toml use not_in = ["comment", "string"], and
; these captures are what give those names meaning. Without this file the
; editor would happily auto-close a quote inside a comment.

(comment) @comment

(quoted_attribute_value) @string

(raw_text) @string

[
  (start_tag)
  (end_tag)
] @default
