
#!/bin/bash

# Get current profile
current=$(asusctl profile -p | grep -oE 'Quiet|Balanced|Performance')

# Toggle to next profile
case "$current" in
  Quiet)
    asusctl profile -P Balanced
    notify-send -u low -t 2500 -i fan "Fan Profile" "Switched to Balanced"
    ;;
  Balanced)
    asusctl profile -P Performance
    notify-send -u low -t 2500 -i fan "Fan Profile" "Switched to Perfomance"
    ;;
  Performance)
    asusctl profile -P Quiet
    notify-send -u low -t 2500 -i fan "Fan Profile" "Switched to Quiet"
    ;;
  *)
    asusctl profile -P Balanced
    notify-send "Fan Profile" "Set to Balanced (unknown previous state)"
    ;;
esac

# notify-send -u low -t 2500 -i fan "Fan Profile" "Switched to Balanced"


