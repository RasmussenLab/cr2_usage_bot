# specify target
# https://stackoverflow.com/questions/645992/sleep-until-a-specific-time-date
# TARGET='02/17/2022 10:00' # MM/dd/YYYY hh:mm
while :
do
  TARGET='next Thursday 11:50'
  echo "Next execution: $(date -d "$TARGET")"

  current_date=$(date +%s)
  target_date=$(date -d "$TARGET" +%s)

  sleep_seconds=$(( $target_date - $current_date ))
  # echo "Sleep for (seconds): $sleep_seconds"
  sleep $sleep_seconds

  bash jobscript.sh
done