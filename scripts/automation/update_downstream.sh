#!/bin/bash

source config.env

export COMMIT_TITLE="chore: Components automatic update."
export COMMIT_BODY="Sync components with $PROFILE repo"
git config --global user.email "$EMAIL"
git config --global user.name "$NAME"
echo "cd'ing into $REPO_COMPONENT_DEFINITION"
pwd
cd "$REPO_COMPONENT_DEFINITION"
git checkout -b "components_autoupdate_$GITHUB_RUN_ID"
ls
ls ../
cp -r ../component-definitions .
if [ -z "$(git status --porcelain)" ]; then 
  echo "Nothing to commit"
else
  git add component-definitions
  if [ -z "$(git status --untracked-files=no --porcelain)" ]; then 
     echo "Nothing to commit"
  else
     git commit --message "$COMMIT_TITLE"
     remote=$URL_COMPONENT_DEFINITION
     git push -u "$remote" "components_autoupdate_$GITHUB_RUN_ID"
     echo $COMMIT_BODY
     gh pr create -t "$COMMIT_TITLE" -b "$COMMIT_BODY" -B "develop" -H "components_autoupdate_$GITHUB_RUN_ID" 
  fi
fi
