"use strict";

const fs = require("fs");
const STDIN_FD = 0;

try {
  printZone(process.argv[2]);
} catch ({message}) {
  process.stderr.write(`${message}\n`);
  process.exitCode = 1;
}

function printZone(zoneName) {
  const {date, zones} = parseData();
  const zone = zones[zoneName];

  if (!zone) {
    throw new Error(`Unknown zone: ${zoneName}`);
  }
  const minTime = Object.entries(zone.times).find(([ , price ]) => price === zone.min).shift();
  const maxTime = Object.entries(zone.times).find(([ , price ]) => price === zone.max).shift();

  process.stdout.write(`Date: ${date.split("-").reverse().join("-")}\n`);
  process.stdout.write(`Zone: ${zoneName}\n`);
  process.stdout.write(`Min:  ${minTime}${zone.min.padStart(9, " ")} EUR/MWh\n`);
  process.stdout.write(`Max:  ${maxTime}${zone.max.padStart(9, " ")} EUR/MWh\n`);
  process.stdout.write(`Avg:  ${zone.average.padStart(16, " ")} EUR/MWh\n`);
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
