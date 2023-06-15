#!/usr/bin/env bash

source ~/scripts/bash_functions.sh

zone="SE3"
format="compact"
use_cached_currencies=false
currency_file=/tmp/currencies.json

for arg in "$@"; do
  case $arg in
    -c)
    DEBUG_LOG "Arg – use caches currencies"
    use_cached_currencies=true
      ;;
    -a)
    DEBUG_LOG "Arg – format: all "
    format="all"
      ;;
    -g)
    DEBUG_LOG "Arg – format: graph "
    format="graph"
      ;;
    -l)
    DEBUG_LOG "Arg – List zones "
      ;&
    *)
    zone=$arg
      ;;
  esac
done

download_currencies() {
  DEBUG_LOG "Downloading new currencies"
  curl -s https://openexchangerates.org/api/latest.json?app_id=$OPEN_EXCHANGE_APP_ID > $currency_file
}

DEBUG_LOG "Currency file path: $currency_file"

if [[ ! -e $currency_file ]]; then
  DEBUG_LOG "File not found"
  if [[ $use_cached_currencies == true ]]; then
    echo "No cached currencties found" >&2
    exit 1
  fi
  download_currencies
else
  currency_date=$(jq .timestamp $currency_file)
  if [[ -z $currency_date ]]; then
    echo "Invalid timestamp in cached currencies, removing file" >&2
    rm $currency_file
    exit 1
  else
    DEBUG_LOG "Currencies found from $(ts2date $currency_date)"
  fi

  if [[ $(($(date +%s) - ${currency_date:-0})) -gt 3600 && $use_cached_currencies == false ]]; then
    download_currencies
  fi
fi

euro_rate=$(jq .rates.EUR $currency_file)
sek_rate=$(jq .rates.SEK $currency_file)

DEBUG_LOG "Zone  = $zone"
DEBUG_LOG "1 USD = $euro_rate EUR"
DEBUG_LOG "1 USD = $sek_rate SEK"
DEBUG_LOG "------"


pbpaste | node ~/scripts/nord-pool.js $zone $euro_rate $sek_rate $format
