#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

let dir = process.cwd();

while (!fs.existsSync(`${dir}/.git`) && dir !== "/") {
  dir = path.resolve(dir, "..");
}

if (dir === "/") {
  process.stderr.write("Not inside a Git repository\n");
  process.exit(1);
}
process.stdout.write(`${dir}\n`);
