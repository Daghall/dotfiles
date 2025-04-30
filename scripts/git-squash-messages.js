#!/usr/bin/env node
"use strict";

const { execSync } = require("child_process");

const branch = process.argv[2] || "master";

try {
  const commits = execSync(`git log --oneline --left-right ...${branch}`, {stdio: "pipe"})
    .toString()
    .split("\n")
    .filter((line) => !!line)
    .map((line) => {
      return line.split(" ")[1];
    });

  commits.forEach((commit) => {
    const commitLines = execSync(`git log -n 1 --pretty=format:%B ${commit}`)
      .toString()
      .split("\n");

    const firstLine = commitLines.shift();

    process.stdout.write(`- **${firstLine}**\n`);
    let level = 1;
    commitLines.forEach((line) => {
      if (line.length === 0) {
        level = 1;
        return;
      } else if (level === 1) {
        process.stdout.write(`  - ${line}\n`);
        level = 2;
      } else {
        process.stdout.write(`    ${line}\n`);
      }
    });
  });
} catch (error) {
  process.stderr.write(`${error.message}\n`);
}
