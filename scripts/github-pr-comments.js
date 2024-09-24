#!/usr/bin/env node
"use strict";

// The /reviews route returns ALL* comments, but the body property is the
// empty string on reviews.
//
// The /comments route returns the review comments with the body property
// set, but not comments left outside of reviews.
//
// 🙄 😵 🤔
//
// So we need to fetch both arrays and merge them, and then sort them by
// date, to get them in chronological order.
//
// There is no connection between the comments and the reviews, so we need to
// aggregate them by commentId (which is the hunk_id) for the reviews. They
// are sorted by date, so the first with a commentId is the parent. All other
// comments with the same commentId are added as children.
//
// * Sometimes, PR comments are not available through the `gh api … /reviews`
// command, so we need to use the `gh pr view` command as a fallback, because
// that one does not always return anything. Ugh.

const {exec} = require("child_process");
const args = process.argv.slice(2);
const [repo, prNumber] = args;

if (!repo || !prNumber) {
  process.stderr.write("Usage: github-pr-comments.js <repo> <prNumber>\n");
  process.exit(1); // eslint-disable-line no-process-exit
}

const commentsCommand = `gh api /repos/${repo}/pulls/${prNumber}/comments`;
const reviewCommentsCommand = `gh api /repos/${repo}/pulls/${prNumber}/reviews`;
const alternativeCommentsCommand = `gh pr view ${prNumber} --json comments`;

(async () => {
  const comments = await fetchData(commentsCommand).catch(errorHandler);
  let altComments = await fetchData(alternativeCommentsCommand).catch(errorHandler);

  if (altComments.length === 0) {
    altComments = await fetchData(reviewCommentsCommand).catch(errorHandler);
  }

  const aggregatedComments = comments
    .reduce((acc, item) => {
      const parent = acc[item.commentId];
      if (parent) {
        parent.children.push(item);
      } else {
        acc[item.commentId] = item;
        item.children = [];
      }

      return acc;
    }, {});

  const allData = [...Object.values(aggregatedComments), ...altComments]
    .sort((a, b) => new Date(a.date) - new Date(b.date));

  if (allData.length === 0) {
    process.stdout.write("–\n");
    return;
  }

  for (const [, comment] of Object.entries(allData)) {
    printComment(comment);
    if (comment.children) {
      comment.children.forEach((child, i) => printComment(child, i, true));
    }
  }
})();

const tree = {
  parent: {
    header: "\n┬",
    middle: "│",
    trailer: "│",
  },
  firstChild: {
    header: "└───┬",
    middle: "    │",
    trailer: "    │",
  },
  child: {
    header: "    ├",
    middle: "    │",
    trailer: "    │",
  },
};
function printComment(comment, index = 0, isChild = false) {
  const {header, middle, trailer} = isChild
    ? tree[index > 0 ? "child" : "firstChild"]
    : tree.parent;
  const [date, time] = new Date(comment.date).toLocaleDateString("sv-SE", {yeah: null, hour: "2-digit", minute: "2-digit"}).split(" ");
  process.stdout.write(`${header}\x1b[32m ${comment.userId}  \x1b[34m${date} · ${time}\x1b[0m\n`);
  process.stdout.write(`${middle} ${comment.body.split("\n").join(`\n${middle} `)}\n`);
  process.stdout.write(`${trailer}\n`);
}

function fetchData(command) {
  debug("Fetching data from", command);

  return new Promise((resolve, reject) => {
    exec(command, (error, stdout) => {
      if (error) return reject(error);

      try {
        const data = JSON.parse(stdout);
        debug({data});

        const mappedData = (data.comments || data).map(commentMapper);
        debug({mappedData});

        const filteredData = mappedData.filter((item) => item.body);
        debug({filteredData});

        resolve(filteredData);
      } catch (err) {
        reject(err);
      }
    });
  });
}

function commentMapper(comment) {
  return {
    userId: (comment.user || comment.author).login,
    commentId: comment.diff_hunk || comment.id,
    body: comment.body,
    date: comment.created_at || comment.createdAt || comment.submitted_at,
  };
}

function debug(...argv) {
  if (process.env.DEBUG === "1") {
    process.stderr.write("\x1b[32mDEBUG\x1b[0m ");
    for (const arg of argv) {
      process.stderr.write(`${JSON.stringify(arg).replace(/(^"|"$)/g, "") } `);
    }
    process.stderr.write("\n");
  }
}

function errorHandler(error) {
  process.stderr.write(`\x1b[31mERROR\x1b[0m ${error.message}\n`);
  process.exit(1); // eslint-disable-line no-process-exit
}
