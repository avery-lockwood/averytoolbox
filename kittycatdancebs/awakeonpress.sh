#!/bin/bash
# filepath: ~/awakeonpress.sh

BACKLIGHT_PATH="/sys/class/leds/chromeos::kbd_backlight"
BRIGHTNESS_FILE="$BACKLIGHT_PATH/brightness"
MAX_BRIGHTNESS_FILE="$BACKLIGHT_PATH/max_brightness"

# Get the maximum brightness
MAX_BRIGHTNESS=$(cat $MAX_BRIGHTNESS_FILE)

# Calculate the brightness range (10% to 20%)
MIN_BRIGHTNESS=$((MAX_BRIGHTNESS * 1 / 100))
MAX_BREATH_BRIGHTNESS=$((MAX_BRIGHTNESS * 60 / 100))

# Function to check for keypress
check_keypress() {
    keypress=$(sudo showkey --scancodes 2>/dev/null | head -n 1)
    echo "DEBUG: Keypress result: $keypress"
    if [[ $keypress == *"0x"* ]]; then
        return 0
    else
        return 1
    fi
}

# Function to perform the breathing effect
breathe() {
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
}

# Main loop
while true; do
    # Set brightness to minimum when idle
    echo $MIN_BRIGHTNESS | sudo tee $BRIGHTNESS_FILE > /dev/null
    echo "Waiting for keypress..."
    # Wait for a keypress
    if check_keypress; then
        # Perform the breathing effect for 10 breaths
        for ((i = 0; i < 3; i++)); do
            breathe
        done
    fi
done