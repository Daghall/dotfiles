"use strict";

if (process.argv.length !== 3) {
  process.stderr.write(`Usage:\n  ${process.argv[1]} path\n\n`);
  process.exitCode = 1;
  return;
}

const cwd = process.argv.slice().pop();
const config = require(`${cwd}/config/production.json`);

function printNode(node, path = "config") {
  return Object.keys(node).map((key) => {
    const currentNode = node[key];
    const currentString = `${path}.${key}`;
    if (typeof currentNode === "object") {
      return printNode(currentNode, currentString);
    } else {
      return currentString;
    }
  })
    .flat();
}

process.stdout.write(printNode(config).concat("").join("\n"));
