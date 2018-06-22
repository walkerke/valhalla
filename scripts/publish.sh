#!/bin/bash

set -eu
set -o pipefail

echo "node version is:"
which node
node -v


if [[ $(is_pr_merge) ]]; then
      echo "Skipping publishing because this is a PR merge commit"
else
      echo "Commit message: ${COMMIT_MESSAGE}"

      if [[ ${COMMIT_MESSAGE} =~ "[publish binary]" ]]; then
          echo "Publishing"
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
