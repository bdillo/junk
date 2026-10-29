import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
import {
  mkdirSync,
  mkdtempSync,
  readFileSync,
  readdirSync,
  rmSync,
  writeFileSync,
} from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import test from "node:test";
import { fileURLToPath } from "node:url";

const command = fileURLToPath(
  new URL("../bin/visual-bundle.mjs", import.meta.url),
);

function project(html, script) {
  const directory = mkdtempSync(join(tmpdir(), "visual-bundle-test-"));
  writeFileSync(join(directory, "index.html"), html);
  writeFileSync(join(directory, "main.js"), script);
  return directory;
}

function run(directory) {
  return spawnSync(process.execPath, [command, directory], {
    encoding: "utf8",
  });
}

test("bundles an SVG diagram into one portable HTML file", () => {
  const directory = project(
    '<div id="drawing"></div><script type="module" src="./main.js"></script>',
    "import { SVG } from '@visual/svg'; SVG().addTo('#drawing').text('Hello diagram')",
  );
  try {
    const result = run(directory);
    assert.equal(result.status, 0, result.stderr);
    assert.deepEqual(readdirSync(join(directory, "dist")), ["index.html"]);
    const html = readFileSync(join(directory, "dist/index.html"), "utf8");
    assert.match(html, /Hello diagram/);
    assert.doesNotMatch(html, /src="\.\/main\.js"/);
  } finally {
    rmSync(directory, { recursive: true, force: true });
  }
});

test("bundles slide CSS and scripts without a project package", () => {
  const directory = project(
    '<div class="reveal"><div class="slides"><section>Slide</section></div></div><script type="module" src="./main.js"></script>',
    "import Reveal from '@visual/slides'; import '@visual/slides.css'; new Reveal().initialize()",
  );
  try {
    const result = run(directory);
    assert.equal(result.status, 0, result.stderr);
    assert.deepEqual(readdirSync(join(directory, "dist")), ["index.html"]);
    assert.match(
      readFileSync(join(directory, "dist/index.html"), "utf8"),
      /\.reveal/,
    );
  } finally {
    rmSync(directory, { recursive: true, force: true });
  }
});

test("rejects output that depends on another file", () => {
  const directory = project(
    '<img src="/badge.svg"><script type="module" src="./main.js"></script>',
    'document.body.dataset.ready = "yes"',
  );
  try {
    mkdirSync(join(directory, "public"));
    writeFileSync(
      join(directory, "public/badge.svg"),
      '<svg xmlns="http://www.w3.org/2000/svg"/>',
    );
    const result = run(directory);
    assert.notEqual(result.status, 0);
    assert.match(result.stderr, /Expected only dist\/index.html/);
  } finally {
    rmSync(directory, { recursive: true, force: true });
  }
});

test("reports a missing entry point", () => {
  const directory = mkdtempSync(join(tmpdir(), "visual-bundle-test-"));
  try {
    const result = run(directory);
    assert.notEqual(result.status, 0);
    assert.match(result.stderr, /Missing entry point/);
  } finally {
    rmSync(directory, { recursive: true, force: true });
  }
});
