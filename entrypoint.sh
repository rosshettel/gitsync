#!/bin/bash
set -e

FREQUENCY=$(jq -r '.frequency // "hourly"' /config.json)

case "$FREQUENCY" in
  hourly)  CRON="0 * * * *" ;;
  daily)   CRON="0 0 * * *" ;;
  weekly)  CRON="0 0 * * 0" ;;
  monthly) CRON="0 0 1 * *" ;;
  *)
    echo "Unknown frequency '$FREQUENCY'. Must be one of: hourly, daily, weekly, monthly"
    exit 1
    ;;
esac

echo "Setting up sync with frequency: $FREQUENCY ($CRON)"

cat > /var/spool/cron/crontabs/root <<EOF
$CRON /repos/sync.sh
EOF

echo "Running initial sync..."
/repos/sync.sh

echo "Starting crond..."
exec crond -f
