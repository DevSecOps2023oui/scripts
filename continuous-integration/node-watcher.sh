#!/bin/bash

RELATIVE_PATH="/home/ubuntu"
REPOSITORY="${RELATIVE_PATH}/NodeWatcher"
GITHUB="https://github.com/DevSecOps2023oui/NodeWatcher.git"
ENV_FILE="${RELATIVE_PATH}/env/NodeWatcher/.env"

DIST="./dist"
START_FILE="${DIST}/index.js"

CSV_DIR="${DIST}/csv"
OLD_CSV_DIR="${RELATIVE_PATH}/old"

PM2_PROCESS="node-watcher"

# Check if repository exists and pull, if not clone it
if [ -d "$REPOSITORY" ]; then
  cd $REPOSITORY || exit
  # Save csv files if they exist
  if [ -d "$CSV_DIR" ]; then
    cp -avr $CSV_DIR $OLD_CSV_DIR || exit
    rm -rf $CSV_DIR || exit
  fi
  # Pull changes
  git pull || exit
  # Update dependencies
  npm ci || npm i || exit
else
  cd $RELATIVE_PATH || exit
  # Clone repository
  git clone $GITHUB || exit
  cd $REPOSITORY || exit
  # Install dependencies
  npm i || exit
fi

# Copy config files
cp -rf $ENV_FILE $REPOSITORY || exit

# Build
tsc || exit

# Create csv directory
mkdir -p "$CSV_DIR/new" || exit
mkdir -p "$CSV_DIR/processing" || exit
mkdir -p "$CSV_DIR/failed" || exit
mkdir -p "$CSV_DIR/completed" || exit

# Restart pm2
pm2 restart $PM2_PROCESS || pm2 start $START_FILE --name $PM2_PROCESS || exit