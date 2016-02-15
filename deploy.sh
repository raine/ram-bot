#!/usr/bin/env bash

rsync -avzr \
  --exclude 'deploy.sh' \
  --exclude '.git' \
  --include 'node_modules/hubot-factoids' \
  --exclude 'node_modules/*' \
  . ec2:ram-bot/

ssh -t ec2 'cd ram-bot; npm install && npm update && pm2 startOrRestart app.json'
