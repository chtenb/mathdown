# mathdown

Markdown + math: write mathematics in Unicode inside ordinary Markdown code spans and
fences, and get a LaTeX-quality PDF through pandoc.

````markdown
**Theorem (Uniqueness of the identity).** If `e` and `e'` are identities of a monoid `M`, then `e = e'`.
*Proof.* Using each one as the identity in turn,
```
e = e ⋅ e'    (e' is an identity)
  = e'        (e is an identity)
```
as claimed.
∎
````

Because the math lives in code spans and fences, a mathdown document pastes into any
Markdown renderer (GitHub, messaging apps, forums, editors) and stays readable as
monospaced text, alignment included.

## Syntax

| You write | You get |
|---|---|
| `` `a ⊆ b` `` | inline math; any Unicode math symbol works |
| a fence without a language | displayed math |
| lines in a fence | aligned on `⟺ ⟹ ⟸`, else on `:= = ≤ ⊆`; lines without one are centred |
| `x = y    (reason)` | a column of justifications (2+ spaces before the parentheses) |
| `a := b     c := d` | side-by-side columns (3+ spaces) |
| `x ⊓ y := x    if x ≤ y` | a cases block |
| `**Theorem (Name).**` … | a numbered theorem; also Lemma, Proposition, Corollary, Definition, Example, Remark, Axiom, Notation, Claim, Conjecture |
| `*Proof.*` … `∎` | a proof, ending at the `∎` |
| no blank line after a fence, list or quote | the paragraph continues, as in LaTeX |
| a blank line there | a new paragraph |

Inside math: `x₁`, `xⁿ` and `x_{i,j}` are subscripts and superscripts;
multi-letter names such as `Obs` are set upright; two lowercase letters such
as `ab` are a product; `and`, `if`, `iff`, … are text; raw TeX such as
`\alpha` passes through. A code span or fence with a class
(`` `x`{.code} ``, ` ```lua `) stays code.

Per document, in the front matter:

```yaml
numbersections: true                  # also prefixes theorem numbers: Theorem 2.3
toc: true
mathdown-align: [["⟺"], ["=", "⊆"]]   # alignment relations, by precedence
```

## Use

```sh
pandoc -d mathdown -d mathdown-default doc.md -o doc.pdf
```

`mathdown` is the core: the reader, the filter and the LaTeX they need.
`mathdown-default` is the default look; replace it with your own settings
file, or add yours after it with another `-d`. The core leaves
`header-includes` free for your documents.

Requires pandoc 3 and TeX Live with `amsthm`, `mathtools` and
`unicode-math-input` (on Ubuntu: `texlive-latex-extra`). Works with pdflatex
(default, fastest), xelatex and lualatex.

## Install

Pandoc has no package manager: it finds readers, filters and settings files
in the subfolders `custom/`, `filters/` and `defaults/` of a data folder.
This repository has exactly that layout, so there are two ways to use it.

**For all your documents:** link it into pandoc's user data folder.

```sh
git clone <this repository> ~/src/mathdown
~/src/mathdown/install.sh
```

**Per project:** keep a copy next to the document, for example as a git
submodule, and point pandoc at it.

```sh
git submodule add <this repository> mathdown
pandoc --data-dir=mathdown -d mathdown -d mathdown-default doc.md -o doc.pdf
```

The per-project copy keeps each document building with the version it was
written for. Note that `--data-dir` replaces your personal pandoc data folder
for that build.

## Customising the look

`mathdown/default.tex` holds the default LaTeX style (theorem heads on their
own line, numbering, list spacing). To make your own, copy it, change it and
include it from your settings file:

```yaml
include-in-header:
  - my-style.tex
```

The core defines the theorem environments (`mdtheorem`, `mddefinition`, …)
only if your style has not, so you can give them your own look, numbering
or names.
