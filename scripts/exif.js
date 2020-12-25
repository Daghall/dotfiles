#!/usr/bin/env node

"use strict";

const {exec} = require("child_process");

const filename = process.argv[2];


printExifData(filename);

function getExifData(file) {
  return new Promise((resolve) => {
    const exif = {};

    exec(`mdls ${file}`, (error, output, stderr) => {
      if (error) return process.stderr.write(stderr);

      let currentKey = null;

      output.split("\n").forEach((row) => {
        const [key, value] = row.split("=").map((s) => s.trim().replace("kMDItem", ""));
        if (value === "(") {
          currentKey = key;
          exif[currentKey] = [];
        } else if (key === ")") {
          currentKey = null;
        } else if (currentKey) {
          exif[currentKey].push(trim(key));
        } else {
          if (key) {
            exif[key] = trim(value);
          }
        }
      });

      resolve(exif);
    });
  });
}

function trim(str = "") {
  return str.replace(/(^["(]|["),]$)/g, "").trim();
}

async function printExifData(file) {
  const {
    AcquisitionModel,
    FNumber,
    FocalLength,
    ExposureTimeSeconds,
    ISOSpeed,
    LensModel,
  } = await getExifData(file);

  const exposureTime = ExposureTimeSeconds < 1 ? `1/${Math.round(1 / ExposureTimeSeconds)}` : `${ExposureTimeSeconds}`;

  process.stdout.write(`${AcquisitionModel}, ${LensModel}\n${FocalLength} mm, ${exposureTime} s, ƒ/${FNumber}, ISO ${ISOSpeed}\n`);
}
