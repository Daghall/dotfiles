#!/usr/bin/env bash

gh api graphql -f query='
{
  viewer {
    repositoriesContributedTo(first: 100, contributionTypes: [COMMIT]) {
      nodes {
        name
        owner {
          login
        }
      }
    }
  }
}' --jq '.data.viewer.repositoriesContributedTo.nodes[] | "\(.owner.login)/\(.name)"' | sort
