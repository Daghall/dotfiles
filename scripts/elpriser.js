#!/usr/bin/env node
"use strict";

const ONE_DAY_IN_MS = 24 * 60 * 60 * 1000;
const TIME_AND_PRICE_WIDTH = 23;
const MAX_BAR_WIDTH = process.stdout.columns - TIME_AND_PRICE_WIDTH;
const RESET = "\x1b[0m";
const GREEN = "\x1b[1m\x1b[32m";
const YELLOW = "\x1b[0m\x1b[33m";
const RED = "\x1b[0m\x1b[31m";

const ZONES = ["SE1", "SE2", "SE3", "SE4" ];

(async () => {
  try {
    const {zoneName, format, date} = processArgv(process.argv.slice(2));
    await printZone(zoneName, date, format).catch((error) => {
      throw error;
    });
  } catch ({message}) {
    if (message) {
      process.stderr.write(`${message}\n\n`);
    }
    printUsage();
    process.exitCode = 1;
  }
})();

async function printZone(zoneName, date, format) {
  if (!zoneName) zoneName = "SE3";
  if (!date) date = new Date().toISOString().split("T").shift();

  if (format === "list") {
    process.stdout.write(ZONES.concat("").join("\n"));
    return;
  }

  if (!ZONES.includes(zoneName)) {
    throw new Error(`Unknown zone: ${zoneName}`);
  }

  const data = await getData(zoneName, date);

  const times = Object.entries(data.times);

  const minTime = times.find(([ , price ]) => price === data.min)[0];
  const maxTime = times.find(([ , price ]) => price === data.max)[0];
  const minPrice = formatPrice(data.min, 9);
  const maxPrice = formatPrice(data.max, 9);
  const averageFloat = data.average;

  process.stdout.write(`Date: ${date}\n`);
  process.stdout.write(`Zone: ${zoneName}\n`);

  if (["all", "graph"].includes(format)) {
    times.forEach(([time, price]) => {
      if (time === minTime) {
        process.stdout.write(GREEN);
      } else if (time === maxTime) {
        process.stdout.write(RED);
      } else if (price > averageFloat) {
        process.stdout.write(YELLOW);
      }

      process.stdout.write(`${time}${formatPrice(price, 7)} `);

      if (format === "graph") {
        printBar(price, data.max);
      } else {
        if (time === minTime) {
          process.stdout.write("MIN");
        } else if (time === maxTime) {
          process.stdout.write("MAX");
        } else {
          process.stdout.write(price > averageFloat ? "+" : "-");
        }
      }
      process.stdout.write(`${RESET}\n`);
    });

  } else {
    const averagePrice = formatPrice(data.average, 16);
    process.stdout.write(`Min:  ${minTime}${minPrice}\n`);
    process.stdout.write(`Max:  ${maxTime}${maxPrice}\n`);
    process.stdout.write(`Avg:  ${averagePrice}\n`);
  }

  function formatPrice(price, padding) {
    return `${price.toFixed(0).padStart(padding, " ")} öre/kWh`;
  }
}

async function getData(zoneName, date) {
  const data = await fetchData(zoneName, date);
  const formatedData = {};

  formatedData.times = data.reduce((acc, hour) => {
    const startTime = hour.time_start.split("T").pop().split(":").shift();
    const endTime = hour.time_end.split("T").pop().split(":").shift();
    acc[`${startTime} - ${endTime}`] = hour.SEK_per_kWh * 125;
    return acc;
  }, {});

  const prices = Object.values(formatedData.times);

  formatedData.min = Math.min(...prices);
  formatedData.max = Math.max(...prices);
  formatedData.average = prices.reduce((acc, current) => acc + current) / 24;

  return formatedData;
}

function fetchData(zoneName, date) {
  const [year, month, day] = date.split("-");
  const url = `https://www.elprisetjustnu.se/api/v1/prices/${year}/${month}-${day}_${zoneName}.json`;
  return new Promise((resolve, reject) => {
    fetch(url)
      .then((result) => result.json())
      .then(resolve)
      .catch(reject);
  });
}

function printBar(price, max) {
  const bar = Array(Math.floor((price / max) * MAX_BAR_WIDTH))
    .fill("▇")
    .join("");
  process.stdout.write(bar);
}

function processArgv(argv) {
  const args = {};

  for (let i = 0; i < argv.length; ++i) {
    switch (argv[i]) {
      case "-z":
      case "--zone":
        args.zoneName = argv[++i];
        break;
      case "-d":
      case "--date":
        args.date = argv[++i];
        break;
      case "-t":
      case "--tomorrow":
        args.date = new Date(Date.now() + ONE_DAY_IN_MS).toISOString().split("T").shift();
        break;
      case "-y":
      case "--yesterday":
        args.date = new Date(Date.now() - ONE_DAY_IN_MS).toISOString().split("T").shift();
        break;
      case "-l":
      case "--list":
        args.format = "list";
        break;
      case "-a":
      case "--all":
        args.format = "all";
        break;
      case "-g":
      case "--graph":
        args.format = "graph";
        break;
      case "-h":
      case "--help":
        throw new Error("");
      default:
        throw new Error(`Unknown flag: ${argv[i]}`);
    }
  }

  return args;
}

function printUsage() {
  process.stdout.write(`Print electrical prices in Sweden.

Usage: ./${process.argv[1].split("/").at(-1)} [flags]
    -z, --zone <zone-name>     Zone name
    -d, --date <date-string>   Datestring in the format YYYY-MM-DD
    -t, --tomorrow             Set date to tomorrow
    -y, --yesterday            Set date to yesterday
    -l, --list                 List available zones
    -a, --all                  Show all times, not max and min
    -g, --graph                Show all times, with a graph
    -h, --help                 Show help
`);
}
