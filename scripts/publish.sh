#!/bin/bash

set -eu
set -o pipefail

echo "node version is:"
which node
node -v


function is_pr_merge() {
  # Get the commit message via git log
  # This should always be the exactly the text the developer provided
  local COMMIT_LOG=${COMMIT_MESSAGE}

  # Get the commit message via git show
  # If the gitsha represents a merge then this will
  # look something like "Merge e3b1981 into 615d2a3"
  # Otherwise it will be the same as the "git log" output
  export COMMIT_SHOW=$(git show -s --format=%B | tr -d '\n')

  if [[ "${COMMIT_LOG}" != "${COMMIT_SHOW}" ]]; then
     echo true
  fi
}


if [[ $(is_pr_merge) ]]; then
      echo "Skipping publishing because this is a PR merge commit"
else
      echo "Commit message: ${COMMIT_MESSAGE}"

      if [[ ${COMMIT_MESSAGE} =~ "[publish binary]" ]]; then
          echo "Publishing"
          echo "dumping binary meta..."
          ./node_modules/.bin/node-pre-gyp package publish $@
      elif [[ ${COMMIT_MESSAGE} =~ "[republish binary]" ]]; then
          echo "Re-Publishing"
          ./node_modules/.bin/node-pre-gyp package unpublish publish $@
      else
          echo "Skipping publishing since we did not detect either [publish binary] or [republish binary] in commit message"
      fi
fi

# if [[ ${PUBLISH} == 'On' ]]; then
#     echo "PUBLISH is set to '${PUBLISH}', publishing!"
#     NPM_FLAGS=''
#     if [[ ${BUILD_TYPE} == "Debug" ]]; then
#         NPM_FLAGS='--debug'
#     fi
#
#     echo "dumping binary meta..."
#     ./node_modules/.bin/node-pre-gyp reveal $NPM_FLAGS
#
#     ./node_modules/.bin/node-pre-gyp package publish info $NPM_FLAGS
# else
#     echo "PUBLISH is set to '${PUBLISH}', skipping."
# fi
