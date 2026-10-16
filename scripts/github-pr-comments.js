#!/usr/bin/env node
"use strict";

// The /issues/comments route returns comments on the PR as a whole.
//
// The /pulls/comments route returns the comments on the individual lines of
// code in the PR.
//
// The /pulls/review route returns the comments left via the review process
//
// Since we are interested in all of them, we need to fetch all arrays and
// merge them, and then sort them by date, to get them in chronological order.
//
// There is no connection between the comments and the reviews, so we need to
// aggregate them by commentId (which is the hunk_id) for the reviews. They
// are sorted by date, so the first with a commentId is the parent. All other
// comments with the same commentId are added as children.

const {exec} = require("child_process");
const args = process.argv.slice(2);
const [repo, prNumber] = args;

if (!repo || !prNumber) {
  process.stderr.write("Usage: github-pr-comments.js <repo> <prNumber>\n");
  process.exit(1); // eslint-disable-line no-process-exit
}

const prCommentsCommand = `gh api /repos/${repo}/issues/${prNumber}/comments`;
const reviewCommentsCommand = `gh api /repos/${repo}/pulls/${prNumber}/comments`;
const prReviewCommentsCommand = `gh api /repos/${repo}/pulls/${prNumber}/reviews`;

(async () => {
  const prComments = await fetchData(prCommentsCommand).catch(errorHandler);
  const reviewComments = await fetchData(reviewCommentsCommand).catch(errorHandler);
  const prReviewComments = await fetchData(prReviewCommentsCommand).catch(errorHandler);

  const aggregatedComments = prComments.concat(reviewComments, prReviewComments)
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

  const allData = [...Object.values(aggregatedComments)]
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
  const [date, time] = new Date(comment.date).toLocaleDateString("sv-SE", {
    year: undefined,
    hour: "2-digit",
    minute: "2-digit",
  }).split(" ");
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
