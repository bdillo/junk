---
name: visualize
description:
  Create and revise standalone technical diagrams or slide decks with reusable
  SVG visuals and optional browser animations. Use when the user wants to
  understand, explain, or present a concept visually.
---

# Visualize

Build diagrams with SVG.js; use Reveal.js when the result is a slide deck. The
default deliverable is one self-contained HTML file that opens directly with
`file://` and can be copied anywhere. Keep source code editable and diagram
rendering functions reusable. Build with the Nix-installed `visual-bundle`
command; individual visuals do not need a `package.json`, Vite config, or dev
server.

## Workflow

1. Establish the concept and intended use: a single diagram for exploration, or
   a slide deck for an audience. Ask only for missing decisions that materially
   affect the result; otherwise make reasonable assumptions and show a first
   draft.
2. Sketch the visual story and any useful stages. Check technical claims before
   encoding them visually. Favor readable labels over decorative complexity.
3. Build the core diagram first. Use HTML/CSS for surrounding text and layout;
   keep the SVG.js drawing in a module exposing a function that takes a
   container. For a deck, compose it into Reveal.js slides and expand only after
   the first visual works.
4. Animate only when it helps explain the concept. For decks, use Reveal.js
   fragments for discrete reveals. Start continuous animations when their slide
   becomes visible; revisiting should be predictable.
5. Put `index.html` and source modules in a folder. Import `{ SVG }` from
   `@visual/svg`; for decks, import `Reveal` from `@visual/slides` and
   `@visual/slides.css`. Run `visual-bundle <folder>` to produce its sole
   output, `<folder>/dist/index.html`. Do not require external assets or another
   file to use it. If both a standalone diagram and a deck are requested, build
   independent files from the same diagram module.
6. Open the output via `file://`. Inspect at the intended size, check any
   animation and navigation, and fix clipping, overlap, contrast, and timing.
   Report what was tested and what could not be verified.

Keep animations in the browser runtime. A static SVG export does not retain
SVG.js JavaScript animations; PDF exports are static snapshots. Avoid requiring
Typst or PowerPoint conversion for this workflow unless the user explicitly
requests it.
