#!/bin/bash
echo "Removing node modules"
rm -rf node_modules/

echo "Cleaning node cache"
npm cache clean --force

echo "Reverting package-lock.json"
git checkout package-lock.json

echo "Reinstalling node modules"
npm i
