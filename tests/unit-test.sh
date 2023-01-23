#!/bin/bash
API_BASE_URL="18.135.6.131"
touch response.txt
response=$(curl -s -o /dev/null -w "%{http_code}" $API_BASE_URL/)
RESPONSES+=("$response")
if [[ $response == *"200"* ]]; then
  echo "GET Request to / was successful." >> response.txt
else
  echo "GET Request to / failed." >> response.txt
fi
response=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "quote=quoteForTesting" $API_BASE_URL/new-quote)
RESPONSES+=("$response")
if [[ $response == *"200"* ]]; then
  echo "POST Request to /new-quote was successful." >> response.txt
else
  echo "POST Request to /new-quote failed." >> response.txt
fi
for item in "${RESPONSES[@]}"; do
  if [[ $item == 200 ]]; then
    continue
  else
    echo "Test Failed"
    exit 1
  fi
done