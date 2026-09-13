; The symbol outline, used by the outline panel, the breadcrumbs above the
; editor, and the file-symbol search.
;
; @item is the row. @name is the text shown for it. Nesting in the panel
; follows nesting in the tree, so no extra work is needed to get the
; hierarchy right.

(comment) @annotation

; Elements and components. Components are worth surfacing most of all,
; since they are the composition points of a template.
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

; Control flow is structure too. Showing the whole opening tag means the
; row reads as "{%if @count > 10}" rather than a bare "if".
[
  (if_block
    (if_open) @name)
  (for_block
    (for_open) @name)
] @item
