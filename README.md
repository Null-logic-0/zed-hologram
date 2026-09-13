# Hologram for Zed

HOLO template language support for the [Hologram](https://hologram.page/)
Elixir framework: syntax highlighting, indentation, bracket matching, an
outline, and formatting through Hologram's own formatter.

Works on standalone `.holo` files and, just as well, on `~HOLO` sigils inside
`.ex` files, which is how most Hologram code is written.

## What it does

| | |
| --- | --- |
| Highlighting | tags, components, `$event` bindings, control-flow blocks, expressions, comments, escapes |
| Embedded languages | Elixir inside `{...}`, JavaScript in `<script>`, CSS in `<style>` and in `style="..."` |
| Editing | auto-indent, bracket matching and auto-close, `cmd-/` comment toggle, tag wrapping |
| Navigation | outline panel and breadcrumbs for elements, components and blocks |
| Formatting | delegates to `mix format`, which uses Hologram's formatter |

## Templates inside `.ex` files

Most Hologram code keeps the template next to the module, in a `~HOLO` sigil:

```elixir
def template do
  ~HOLO"""
  <div class="posts">
    {%for post <- @posts}
      <PostPreview post={post} />
    {/for}
  </div>
  """
end
```

This works with no extra configuration. Zed's Elixir extension injects the
body of a `~HOLO` sigil into a language named `holo`, and Zed resolves that
name against a language's name or its file suffixes, so installing this
extension is enough to satisfy it. You get three languages nested in one
buffer: Elixir around the sigil, HOLO inside it, and Elixir again inside
every `{...}`.

Two requirements:

- Zed's **Elixir extension 0.6.3 or newer**. The HOLO sigil injection was
  added in that release. Earlier versions leave the sigil body unhighlighted.
- This extension installed, so the `holo` language exists.

**Formatting a `.ex` file is a separate setting.** Zed picks a formatter by
the buffer's language, and for `foo.ex` that is Elixir, not HOLO. The `HOLO`
entry above does not apply. Sigil bodies are only reformatted if whatever
formats your Elixir ends up running `mix format` with the Hologram plugin
configured. `mix format` does handle `~HOLO` sigils, so the most direct way
to guarantee it is to format Elixir with the same command:

```json
{
  "languages": {
    "Elixir": {
      "formatter": {
        "external": {
          "command": "mix",
          "arguments": ["format", "--stdin-filename", "{buffer_path}", "-"]
        }
      }
    }
  }
}
```

If you prefer `"formatter": "language_server"`, whether sigils get formatted
depends on your Elixir language server honouring the project's
`.formatter.exs` plugins.

A complete example module is in [examples/home_page.ex](examples/home_page.ex).

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

This section covers `.holo` files. For templates written as `~HOLO` sigils
inside `.ex` files, see [Templates inside `.ex` files](#templates-inside-ex-files):
those are formatted by your Elixir settings, not by the `HOLO` entry.

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
