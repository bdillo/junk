#!/usr/bin/env node
import { existsSync, readdirSync, statSync } from "node:fs";
import { join, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { build } from "vite";
import { viteSingleFile } from "vite-plugin-singlefile";

const usage = "Usage: visual-bundle <source-directory>";
const directory = process.argv[2];
if (process.argv.length !== 3 || !directory || directory.startsWith("-")) {
  console.error(usage);
  process.exitCode = 1;
} else {
  const root = resolve(directory);
  const input = join(root, "index.html");
  if (!existsSync(input) || !statSync(input).isFile()) {
    console.error(`Missing entry point: ${input}`);
    process.exitCode = 1;
  } else {
    try {
      const library = (name) => fileURLToPath(import.meta.resolve(name));
      await build({
        configFile: false,
        root,
        base: "./",
        plugins: [viteSingleFile()],
        resolve: {
          alias: [
            {
              find: /^@visual\/svg$/,
              replacement: library("@svgdotjs/svg.js"),
            },
            { find: /^@visual\/slides$/, replacement: library("reveal.js") },
            {
              find: /^@visual\/slides\.css$/,
              replacement: library("reveal.js/reveal.css"),
            },
          ],
        },
        build: {
          outDir: "dist",
          emptyOutDir: true,
          rolldownOptions: { input },
        },
      });

      const output = join(root, "dist");
      const files = readdirSync(output, { recursive: true }).filter((name) =>
        statSync(join(output, name)).isFile(),
      );
      if (files.length !== 1 || files[0] !== "index.html") {
        throw new Error(
          `Expected only dist/index.html; found: ${files.join(", ")}`,
        );
      }
      console.log(`Wrote ${join(output, "index.html")}`);
    } catch (error) {
      console.error(error);
      process.exitCode = 1;
    }
  }
}
