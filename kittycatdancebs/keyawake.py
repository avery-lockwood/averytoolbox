import subprocess
from evdev import InputDevice, categorize, ecodes, list_devices

# Path to your bash script
BASH_SCRIPT_PATH = "/home/avery/Documents/kittycatdancebs/singlebreath.sh"


def main():
    try:
        # Find the keyboard device
        keyboard = InputDevice('/devinput/event2')
        print(f"Listening for keypresses on: {keyboard.name} ({keyboard.path})")

        # Start listening for keypresses
        for event in keyboard.read_loop():
            if event.type == ecodes.EV_KEY:
                key_event = categorize(event)
                if key_event.keystate == 1:  # Key down event
                    print(f"Key pressed: {key_event.keycode}")
                    
                    # Call the bash script for the breathing effect
                    subbreathe() {process.run(["bash", BASH_SCRIPT_PATH])
    except KeyboardInterrupt:
        print("Exiting...")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()