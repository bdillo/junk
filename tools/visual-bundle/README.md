# visual-bundle

One shared builder for standalone SVG.js diagrams and Reveal.js slide decks. A
visual needs only an `index.html` and optional JS/CSS source; no per-visual
package or server.

```sh
visual-bundle path/to/visual
open path/to/visual/dist/index.html
```

The input HTML can load a local module with
`<script type="module" src="./main.js"></script>`. In that module, import
`{ SVG }` from `@visual/svg`; for slides, import `Reveal` from `@visual/slides`
and `@visual/slides.css`. Other relative JS/CSS imports work normally.

The command bundles everything into `dist/index.html` and fails if the build
emits other files. Avoid external URLs and runtime fetches: the output must also
work offline. Dependencies are pinned in this tool's `package-lock.json` and
installed once by Nix.
