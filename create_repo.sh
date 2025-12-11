#!/bin/bash

# Usage: ./create_repo.sh /path/to/project <repo-name> [--https|--ssh] "description"
# Example: ./create_repo.sh ~/Projects/cool-thing cool-thing -ssh "Cool project i made"

PROJECT_PATH=$1
REPO_NAME=$2
REMOTE_FLAG=$3
REPO_DESC=$4

if [[ -z "$PROJECT_PATH" || -z "$REPO_NAME" ]]; then
  echo "Usage: $0 /path/to/project <repo-name> [--https|--ssh] \"<description>\""
  exit 1
fi

if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "Error: GITHUB_TOKEN not set."
    echo "Set with: export GITHUB_TOKEN=\"your_personal_access_token\""
    exit 1
  fi

USE_SSH=true

if [[ "$REMOTE_FLAG" == "--https" ]]; then
  USE_SSH=false
elif [[ "$REMOTE_FLAG" == "--ssh" ]]; then
  USE_SSH=true
else
  # default to ssh
  REPO_DESC="$REMOTE_FLAG"
fi

echo "Creating remote repository '$REPO_NAME' on GitHub..."
CREATE_RESPONSE=$(curl -s \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/user/repos \
  -d "{
    \"name\": \"$REPO_NAME\",
    \"description\": \"$REPO_DESC\",
    \"private\": false
  }")

if echo "$CREATE_RESPONSE" | grep -q "\"full_name\""; then
  echo "Remote repository created."
else
  echo "Error creating remote repo:"
  echo "$CREATE_RESPONSE"
  exit 1
fi

# grep command will add github username to remote url
REPO_NAME=$(echo "$CREATE_RESPONSE" | grep -oP '(?<=\"full_name\": \")[^\"]+')

if $USE_SSH; then
  REMOTE_URL="git@github.com:$REPO_NAME.git"
else
  REMOTE_URL="https://github.com/:$REPO_NAME.git"
fi

cd "$PROJECT_PATH" || { echo "Invalid project path"; exit 1; }

if [ ! -d .git ]; then
  echo "Initializing local Git repository..."
  git init
fi

git add .
git commit -m "Initial commit"

git remote add origin $REMOTE_URL
git branch -M main

echo "Pushing to remote ($REMOTE_URL)..."
git push -u origin main

echo "Done! Repo available at: $REMOTE_URL"
