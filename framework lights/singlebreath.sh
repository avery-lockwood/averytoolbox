#!/bin/bash
# filepath: ~/breathing_kbd_backlight.sh

BACKLIGHT_PATH="/sys/class/leds/chromeos::kbd_backlight"
BRIGHTNESS_FILE="$BACKLIGHT_PATH/brightness"
MAX_BRIGHTNESS_FILE="$BACKLIGHT_PATH/max_brightness"

# Get the maximum brightness
MAX_BRIGHTNESS=$(cat $MAX_BRIGHTNESS_FILE)

# Calculate the brightness range (10% to 20%)
MIN_BRIGHTNESS=$((MAX_BRIGHTNESS * 1 / 100))
MAX_BREATH_BRIGHTNESS=$((MAX_BRIGHTNESS * 60 / 100))

    # Gradually increase brightness
    for ((i = MIN_BRIGHTNESS; i <= MAX_BREATH_BRIGHTNESS; i+=2)); do
        echo $i | sudo tee $BRIGHTNESS_FILE > /dev/null
        #sleep 0.05 # Adjust for speed
    done

    # Gradually decrease brightness
    for ((i = MAX_BREATH_BRIGHTNESS; i >= MIN_BRIGHTNESS; i-=2)); do
        echo $i | sudo tee $BRIGHTNESS_FILE > /dev/null
        #sleep 0.05 # Adjust for speed
    done
