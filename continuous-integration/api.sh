#!/bin/bash

RELATIVE_PATH="/home/ubuntu"
REPOSITORY="${RELATIVE_PATH}/API"
GITHUB="https://github.com/DevSecOps2023oui/API.git"
ENV_FILE="${RELATIVE_PATH}/env/API/.env"
START_FILE="./dist/app.js"

PM2_PROCESS="node-API"

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

# Copy config files
cp -rf $ENV_FILE $REPOSITORY || exit

# Build
tsc || exit

# Restart pm2
pm2 restart $PM2_PROCESS || pm2 start $START_FILE --name $PM2_PROCESS || exit