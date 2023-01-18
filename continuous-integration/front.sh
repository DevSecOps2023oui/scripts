#!/bin/bash

RELATIVE_PATH="/home/ubuntu"
REPOSITORY="${RELATIVE_PATH}/Front"
GITHUB="https://github.com/DevSecOps2023oui/Front.git"

WWW="/var/www/html"

# Check if repository exists and pull, if not clone it
if [ -d "$REPOSITORY" ]; then
  cd $REPOSITORY || exit
  git pull || exit
  npm ci || npm i || exit
else
  cd $RELATIVE_PATH || exit
  git clone $GITHUB || exit
  cd $REPOSITORY || exit
  npm i || exit
fi

# Build
npm run build || exit

# Copy files to www
sudo cp -avr "$REPOSITORY/build/." $WWWW || exit
