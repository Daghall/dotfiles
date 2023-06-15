"use strict";

const fs = require("fs");
const STDIN_FD = 0;
const VAT_FACTOR = 1.25;
const TIME_AND_PRICE_WIDTH = 23;
const MAX_BAR_WIDTH = process.stdout.columns - TIME_AND_PRICE_WIDTH;
const RESET = "\x1b[0m";
const GREEN = "\x1b[1m\x1b[32m";
const YELLOW = "\x1b[0m\x1b[33m";
const RED = "\x1b[0m\x1b[31m";

try {
  const argv = process.argv.slice(2);
  printZone(...argv);
} catch ({message}) {
  process.stderr.write(`${message}\n`);
  process.exitCode = 1;
}

function printZone(zoneName, fromRate, toRate, format) {
  const {date, zones} = parseData();

  if (zoneName === "-l") {
    process.stdout.write(Object.keys(zones).concat("").join("\n"));
    return;
  }
  const zone = zones[zoneName];

  if (!zone) {
    throw new Error(`Unknown zone: ${zoneName}`);
  }

  const times = Object.entries(zone.times);

  const minTime = times.find(([ , price ]) => price === zone.min)[0];
  const maxTime = times.find(([ , price ]) => price === zone.max)[0];
  const minPrice = reformatPrice(zone.min, 9);
  const maxPrice = reformatPrice(zone.max, 9);
  const averageFloat = toFloat(zone.average);

  process.stdout.write(`Date: ${flipDate(date)}\n`);
  process.stdout.write(`Zone: ${zoneName}\n`);

  if (["all", "graph"].includes(format)) {
    times.forEach(([time, price]) => {
      if (time === minTime) {
        process.stdout.write(GREEN);
      } else if (time === maxTime) {
        process.stdout.write(RED);
      } else if (toFloat(price) > averageFloat) {
        process.stdout.write(YELLOW);
      }

      process.stdout.write(`${time}${reformatPrice(price, 7)} `);

      if (format === "graph") {
        printBar(price, zone.max);
      } else {
        if (time === minTime) {
          process.stdout.write("MIN");
        } else if (time === maxTime) {
          process.stdout.write("MAX");
        } else {
          process.stdout.write(toFloat(price) > averageFloat ? "+" : "-");
        }
      }
      process.stdout.write(`${RESET}\n`);
    });

  } else {
    const averagePrice = reformatPrice(zone.average, 16);
    process.stdout.write(`Min:  ${minTime}${minPrice}\n`);
    process.stdout.write(`Max:  ${maxTime}${maxPrice}\n`);
    process.stdout.write(`Avg:  ${averagePrice}\n`);
  }

  function reformatPrice(price, padding) {
    const usd = parseInt(price.replace(",", "")) / parseFloat(fromRate);
    const cents = usd * parseFloat(toRate) / 1000 * VAT_FACTOR;
    return `${cents.toFixed(0).padStart(padding, " ")} öre/kWh`;
  }
}

function printBar(price, max) {
  const priceFloat = toFloat(price);
  const maxFloat = toFloat(max);
  const bar = Array(Math.floor((priceFloat / maxFloat) * MAX_BAR_WIDTH))
    .fill("▇")
    .join("");
  process.stdout.write(bar);
}

function toFloat(numberString) {
  return parseFloat(numberString.replace(",", "."));
}

function flipDate(date) {
  return date.split("-").reverse().join("-");
}

function parseData() {
  try {
    const data = fs.readFileSync(STDIN_FD)
      .toString()
      .replace(/&nbsp;/g, " ")
      .replace(/'/g, "")
      .replace(/<t[dhr][^>]*>/g, "")
      .replace(/<table[^>]*>/g, "")
      .replace("</tfoot></table>", "")
      .replace("</thead><tbody>", "")
      .replace(/<\/tfoot><\/table>'?/g, "")
      .replace(/<\/t[dh]>/g, "\t")
      .split("</tr>")
      .filter(Boolean)
      .filter((item) => !/^\s+$/.test(item))
      .slice(0, -1);

    const [ date, zoneNames ] = splitAndFilter(data.shift());

    const zones = zoneNames
      .reduce((acc, curr) => {
        acc[curr] = { times: {} };
        return acc;
      }, {});

    const timeRows = data.splice(0, 24);
    const mins = splitAndFilter(data.shift()).pop();
    const maxes = splitAndFilter(data.shift()).pop();
    const averages = splitAndFilter(data.shift()).pop();

    timeRows.forEach((timeRow) => {
      const [ time, prices ] = splitAndFilter(timeRow);
      prices.forEach((price, i) => {
        zones[zoneNames[i]].times[time] = price;
        zones[zoneNames[i]].max = maxes[i];
        zones[zoneNames[i]].min = mins[i];
        zones[zoneNames[i]].average = averages[i];
      });
    });

    return {date, zones};
  } catch (error) {
    throw new Error("Malformed data");
  }
}

function splitAndFilter(arr) {
  const newArr = arr.split("\t").filter(Boolean);
  return [ newArr.shift(), newArr ];
}
