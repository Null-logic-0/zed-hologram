; Outline panel, breadcrumbs and symbol search.
; @item is the row, @name is its label.

(comment) @annotation

[
  (element
    (start_tag
      [
        (tag_name)
        (component_name)
      ] @name))
  (element
    (self_closing_tag
      [
        (tag_name)
        (component_name)
      ] @name))
  (void_element
    (tag_name) @name)
  (script_element
    (start_tag
      (tag_name) @name))
  (style_element
    (start_tag
      (tag_name) @name))
] @item

; Capturing the whole opening tag makes the row read "{%if @count > 10}".
[
  (if_block
    (if_open) @name)
  (for_block
    (for_open) @name)
] @item
