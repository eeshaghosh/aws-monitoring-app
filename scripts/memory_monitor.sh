#!/bin/bash

THRESHOLD=1
USAGE=$(free | awk '/Mem:/ {printf("%.0f"), $3/$2 * 100}')

if [ "$USAGE" -gt "$THRESHOLD" ]; then
  LOG="/tmp/memory_alert_$(date +%F_%T).log"
  echo "Memory usage is ${USAGE}%" > "$LOG"

  aws s3 cp "$LOG" s3://monitoring-logs-eesha/

  aws sns publish \
    --topic-arn arn:aws:sns:ap-south-1:626372426445:memory-alert-topic \
    --message "Memory usage exceeded ${THRESHOLD}%. Current usage: ${USAGE}%"
fi
