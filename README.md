# Hologram for Zed

HOLO template language support for the [Hologram](https://hologram.page/)
Elixir framework: syntax highlighting, indentation, bracket matching, an
outline, and formatting through Hologram's own formatter.

Works on standalone `.holo` files and on `~HOLO` sigils inside `.ex` files.

## What it does

| | |
| --- | --- |
| Highlighting | tags, components, `$event` bindings, control-flow blocks, expressions, comments, escapes |
| Embedded languages | Elixir inside `{...}`, JavaScript in `<script>`, CSS in `<style>` and in `style="..."` |
| Editing | auto-indent, bracket matching and auto-close, `cmd-/` comment toggle, tag wrapping |
| Navigation | outline panel and breadcrumbs for elements, components and blocks |
| Formatting | delegates to `mix format`, which uses Hologram's formatter |

`~HOLO` sigils in `.ex` files light up without any extra setup. Zed's Elixir
extension already injects sigil bodies into a language named `holo`, and this
extension provides it.

## Install

Not yet in Zed's extension registry. To install from source:

```sh
git clone https://github.com/Null-logic-0/zed-hologram
```

Then in Zed, run `zed: install dev extension` from the command palette and
pick the cloned folder. Zed clones the grammar, compiles it to WebAssembly
and registers the language. The first install downloads a WebAssembly
toolchain, so give it a minute.

## Formatting

A Zed extension cannot configure a formatter, so this part is a setting you
add yourself. There are two halves.

**1. Tell Zed to format HOLO with `mix format`.** Put this in a project's
`.zed/settings.json` or in your global `~/.config/zed/settings.json`. A
ready-to-copy version is in [examples/zed-settings.jsonc](examples/zed-settings.jsonc).

```json
{
  "languages": {
    "HOLO": {
      "formatter": {
        "external": {
          "command": "mix",
          "arguments": ["format", "--stdin-filename", "{buffer_path}", "-"]
        }
      },
      "format_on_save": "on"
    }
  }
}
```

**2. Tell `mix format` about HOLO.** In your Hologram project's
`.formatter.exs`:

```elixir
[
  import_deps: [:hologram],
  plugins: [Hologram.Template.Formatter],
  inputs: ["{app,config,lib,test}/**/*.{ex,exs,holo}"]
]
```

The `plugins:` line matters and is easy to miss. Elixir never inherits
formatter plugins through `import_deps`, so naming `:hologram` there is not
enough on its own.

> **The formatter has not shipped yet.** `Hologram.Template.Formatter` is
> [pull request #573](https://github.com/bartblast/hologram/pull/573), still
> open as of Hologram 0.11.1. Until it merges, `mix format` does not
> recognise `.holo` and returns your buffer untouched with a zero exit code.
> Configuring this now is safe: every failure mode is a pass-through, never a
> corrupted buffer. Formatting simply starts working the day the plugin lands.

## How it works

Three layers, in two repositories.

```
.holo file  or  ~HOLO sigil in a .ex file
      |
      v
  Zed reads extension.toml, clones the grammar at the pinned commit,
  compiles src/parser.c to WebAssembly, and parses the buffer
      |
      v
  languages/holo/*.scm run against the resulting syntax tree
      highlights.scm   which node gets which colour
      injections.scm   which ranges belong to Elixir, JavaScript, CSS
      brackets.scm     which nodes form matching pairs
      indents.scm      what indents, and by how much
      outline.scm      what appears in the outline
      overrides.scm    names the regions the bracket rules exclude
      |
      v
  on save: mix format --stdin-filename <path> -
```

The grammar lives in a separate repository,
[tree-sitter-holo](https://github.com/Null-logic-0/tree-sitter-holo), because
Zed fetches grammars by git URL and commit, never from inside an extension
folder. `extension.toml` pins the exact commit.

No Rust and no WebAssembly of our own. Zed needs Rust only for language
servers, context servers and debuggers, and this extension ships none.

## Development

After changing the grammar, the pinned commit has to move with it:

```sh
cd tree-sitter-holo
tree-sitter generate && tree-sitter test
git commit -am "..." && git push          # Zed fetches the commit from GitHub
```

Then set `rev` in `extension.toml` to the new SHA and re-run
`zed: install dev extension`. If `rev` and the grammar disagree, Zed is
running a parser you did not test.

Changing a query alone needs no grammar work. Just reinstall the dev
extension.

## Limitations

- **Raw block bodies are opaque.** Hologram still parses markup inside
  `{%raw}`; we treat the body as one literal span. Expressions are inert
  either way, which is the point of `{%raw}`.
- **No language server.** No completions, go-to-definition, or diagnostics.
- **Bare `<` in text.** Hologram rejects it and so do we, with an error node
  rather than an exception. Use `&lt;`.

## Licence

Copyright (C) 2026 Luka Tchelidze.

Released under the [GNU General Public License v3.0 or later](LICENSE). This
program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY. See the licence for details.

The same licence covers the grammar in
[tree-sitter-holo](https://github.com/Null-logic-0/tree-sitter-holo).
