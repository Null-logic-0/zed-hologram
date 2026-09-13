; Named regions. The bracket rules in config.toml use not_in = ["comment",
; "string"], and these captures are what give those names meaning.

(comment) @comment

(quoted_attribute_value) @string

(raw_text) @string

[
  (start_tag)
  (end_tag)
] @default
