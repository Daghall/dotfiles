"use strict";

const fs = require("fs");
const STDIN_FD = 0;
const VAT_FACTOR = 1.25;

try {
  const argv = process.argv.slice(2);
  printZone(...argv);
} catch ({message}) {
  process.stderr.write(`${message}\n`);
  process.exitCode = 1;
}

function printZone(zoneName, fromRate, toRate) {
  const {date, zones} = parseData();

  if (zoneName === "-l") {
    process.stdout.write(Object.keys(zones).concat("").join("\n"));
    return;
  }
  const zone = zones[zoneName];

  if (!zone) {
    throw new Error(`Unknown zone: ${zoneName}`);
  }
  const minTime = Object.entries(zone.times).find(([ , price ]) => price === zone.min).shift();
  const maxTime = Object.entries(zone.times).find(([ , price ]) => price === zone.max).shift();
  const minPrice = reformatPrice(zone.min, 9);
  const maxPrice = reformatPrice(zone.max, 9);
  const averagePrice = reformatPrice(zone.average, 16);

  process.stdout.write(`Date: ${flipDate(date)}\n`);
  process.stdout.write(`Zone: ${zoneName}\n`);
  process.stdout.write(`Min:  ${minTime}${minPrice}\n`);
  process.stdout.write(`Max:  ${maxTime}${maxPrice}\n`);
  process.stdout.write(`Avg:  ${averagePrice}\n`);

  function reformatPrice(price, padding) {
    const usd = parseInt(price.replace(",", "")) / parseFloat(fromRate);
    const cents = usd * parseFloat(toRate) / 1000 * VAT_FACTOR;
    return `${cents.toFixed(0).padStart(padding, " ")} öre/kWh`;
  }
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
