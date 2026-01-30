#!/bin/bash
set -x

THRESHOLD=1
USAGE=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')

echo "DEBUG: Memory=$USAGE Threshold=$THRESHOLD"

if [ "$USAGE" -gt "$THRESHOLD" ]; then
  echo "DEBUG: Condition matched"

  aws sns publish \
    --region ap-south-1 \
    --topic-arn arn:aws:sns:ap-south-1:626372426445:memory-alert-topic \
    --message "DEBUG TEST: Memory ${USAGE}%"
else
  echo "DEBUG: Condition NOT matched"
fi
