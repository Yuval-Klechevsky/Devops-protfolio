#!/bin/bash
API_BASE_URL="3.9.146.148"
touch response.txt
response=$(curl -s -o /dev/null -w "%{http_code}" $API_BASE_URL/)
RESPONSES+=("$response")
id=$(curl -s $API_BASE_URL/id-for-test)

if [[ $response == *"200"* ]]; then
  echo "GET Request to / was successful." >> response.txt
else
  echo "GET Request to / failed." >> response.txt
fi

response=$(curl -s -o /dev/null -w "%{http_code}" -X GET -H "Content-Type: application/x-www-form-urlencoded"  $API_BASE_URL/subscriptions)
RESPONSES+=("$response")
if [[ $response == *"200"* ]]; then
  echo "GET Request to /subscriptions was successful." >> response.txt
else
  echo "GET Request to /subscriptions failed." >> response.txt
fi

response=$(curl -s -o /dev/null -w "%{http_code}" -X GET -H "Content-Type: application/x-www-form-urlencoded"  $API_BASE_URL/subscriptions/ids)
RESPONSES+=("$response")
if [[ $response == *"200"* ]]; then
  echo "GET Request to /subscriptions/ids was successful." >> response.txt
else
  echo "GET Request to /subscriptions/ids failed." >> response.txt
fi

response=$(curl -s -o /dev/null -w "%{http_code}" -X GET -H "Content-Type: application/x-www-form-urlencoded"  $API_BASE_URL/subscriptions/training_program)
RESPONSES+=("$response")
if [[ $response == *"200"* ]]; then
  echo "GET Request to /subscriptions/training_program was successful." >> response.txt
else
  echo "GET Request to /subscriptions/training_program failed." >> response.txt
fi

response=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/x-www-form-urlencoded" -d '{"first_name": "Lebron ","last_name": "James" ,"birth_date":"30/12/1984","weight": "113","height": "206","training_program": "Full-Body"}' $API_BASE_URL/subscription)
RESPONSES+=("$response")
if [[ $response == *"200"* ]]; then
  echo "POST Request to /subscription was successful." >> response.txt
else
  echo "POST Request to /subscription failed." >> response.txt
fi

response=$(curl -s -o /dev/null -w "%{http_code}" -X PUT -H "Content-Type: application/x-www-form-urlencoded" -d '{"first_name": "Yuval ","last_name": "Klechevsky" ,"birth_date":"27/10/2000","weight": "73","height": "174","training_program": "Full-Body"}' $API_BASE_URL/subscription/$id)
RESPONSES+=("$response")
if [[ $response == *"200"* ]]; then
  echo "PUT Request to /subscription was successful." >> response.txt
else
  echo "PUT Request to /subscription failed." >> response.txt
fi

response=$(curl -s -o /dev/null -w "%{http_code}" -X GET -H "Content-Type: application/x-www-form-urlencoded"  $API_BASE_URL/subscription/$id/BMI)
RESPONSES+=("$response")
if [[ $response == *"200"* ]]; then
  echo "GET Request to /subscription/id/BMI was successful." >> response.txt
else
  echo "GET Request to /subscription/id/BMI failed." >> response.txt
fi

response=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE -H "Content-Type: application/x-www-form-urlencoded"  $API_BASE_URL/subscription/$id)
RESPONSES+=("$response")
if [[ $response == *"200"* ]]; then
  echo "DELETE Request to /subscription was successful." >> response.txt
else
  echo "DELETE Request to /subscription failed." >> response.txt
fi




for item in "${RESPONSES[@]}"; do
  if [[ $item == 200 ]]; then
    continue
  else
    echo "Test Failed"
    exit 1
  fi
done