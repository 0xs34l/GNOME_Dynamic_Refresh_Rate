#Dynamic refresh rate script for GNOME

#!/bin/bash

REFRESH_RATE_UNPLUGGED=60.000       #Change your base rr
REFRESH_RATE_PLUGGEDIN=240.000      #Change your max rr
SCREEN_RESOLUTION=$(gdctl show -p | grep "Dimension" | cut -d: -f2 | xargs)

#BATTERY_STATUS=$(cat /sys/class/power_supply/BAT*/status)
#REFRESH_RATE_STATUS=$(gdctl show -p | grep "Refresh rate" | cut -d: -f2)

while true
do
REFRESH_RATE_STATUS=$(gdctl show -p | grep "Refresh rate" | cut -d: -f2 | xargs)
BATTERY_STATUS=$(cat /sys/class/power_supply/BAT*/status)

if [[ "$BATTERY_STATUS" != "Charging" && "$REFRESH_RATE_STATUS" == "$REFRESH_RATE_PLUGGEDIN" ]]; then
    gdctl set   --layout-mode logical   --logical-monitor   --monitor eDP-1   --mode "$SCREEN_RESOLUTION"@"$REFRESH_RATE_UNPLUGGED"   --primary    
fi

if [[ "$BATTERY_STATUS" == "Charging" && "$REFRESH_RATE_STATUS" == "$REFRESH_RATE_UNPLUGGED" ]]; then
    gdctl set   --layout-mode logical   --logical-monitor   --monitor eDP-1   --mode "$SCREEN_RESOLUTION"@"$REFRESH_RATE_PLUGGEDIN"   --primary
fi
sleep 1 #to reduce cpu stress
done
