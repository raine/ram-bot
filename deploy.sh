#!/usr/bin/env bash

rsync -avzr --delete \
  --exclude 'deploy.sh' \
  --exclude '.git' \
  --exclude 'node_modules' \
  . ec2:ram-bot/

ssh -t ec2 'cd ram-bot; npm install; pm2 startOrRestart app.json'
