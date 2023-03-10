#!/usr/bin/env bash

source ~/scripts/bash_functions.sh

download_currencies() {
  DEBUG_LOG "Downloading new currencies"
  curl -s https://openexchangerates.org/api/latest.json?app_id=$OPEN_EXCHANGE_APP_ID > $currency_file
}

currency_file=/tmp/currencies.json
DEBUG_LOG "Currency file path: $currency_file"

if [[ ! -e $currency_file ]]; then
  DEBUG_LOG "File not found"
  download_currencies
else
  currency_date=$(jq .timestamp $currency_file)
  DEBUG_LOG "Currencies found from $(ts2date $currency_date)"
  if [[ $(($(date +%s) - $currency_date)) -gt 3600 ]]; then
    download_currencies
  fi
fi

zone=${1:-SE3}
euro_rate=$(jq .rates.EUR $currency_file)
sek_rate=$(jq .rates.SEK $currency_file)

DEBUG_LOG "Zone  = $zone"
DEBUG_LOG "1 USD = $euro_rate EUR"
DEBUG_LOG "1 USD = $sek_rate SEK"
DEBUG_LOG "------"

pbpaste | node ~/scripts/nord-pool.js $zone $euro_rate $sek_rate
