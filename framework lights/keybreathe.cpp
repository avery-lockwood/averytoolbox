#include <iostream>
#include <fstream>
#include <thread>
#include <chrono>
#include <atomic>
#include <termios.h>
#include <unistd.h>
#include <fcntl.h>
#include <csignal>
#include <sys/ioctl.h>

const char* BACKLIGHT_PATH = "/sys/class/leds/chromeos::kbd_backlight";
const char* BRIGHTNESS_FILE = "/sys/class/leds/chromeos::kbd_backlight/brightness";
const char* MAX_BRIGHTNESS_FILE = "/sys/class/leds/chromeos::kbd_backlight/max_brightness";

// Breathing parameters
const int BREATH_MIN_PCT = 1;   // 1%
const int BREATH_MAX_PCT = 60;  // 60%
const int DIM_STEP = 2;         // Step for breathing
const int DIM_INTERVAL_MS = 200; // Breathing speed
const int INACTIVITY_TIMEOUT_SEC = 10; // Time to start dimming after inactivity
const int DIMMING_STEPS = 50;   // Steps to fade out

std::atomic<bool> running(true);

// Set brightness value
void set_brightness(int value) {
    std::ofstream ofs(BRIGHTNESS_FILE);
    if (ofs) ofs << value;
    std::cout << "Brightness set to: " << value << std::endl;
}

// Get maximum brightness value
int get_max_brightness() {
    std::ifstream ifs(MAX_BRIGHTNESS_FILE);
    int max_brightness = 100;
    if (ifs) ifs >> max_brightness;
    return max_brightness;
}

// Set terminal to non-canonical, non-blocking mode for keypress detection
void set_nonblocking_terminal(termios& orig_term) {
    termios new_term = orig_term;
    new_term.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &new_term);
    fcntl(STDIN_FILENO, F_SETFL, O_NONBLOCK);
}

// Restore terminal settings
void restore_terminal(const termios& orig_term) {
    tcsetattr(STDIN_FILENO, TCSANOW, &orig_term);
}

// Check for keypress (returns true if a key was pressed)
bool check_keypress() {
    char ch;
    ssize_t n = read(STDIN_FILENO, &ch, 1);
    return n > 0;
}

// Handle Ctrl+C
void signal_handler(int) {
    running = false;
}

int main() {
    signal(SIGINT, signal_handler);

    termios orig_term;
    tcgetattr(STDIN_FILENO, &orig_term);
    set_nonblocking_terminal(orig_term);

    int max_brightness = get_max_brightness();
    int min_brightness = max_brightness * BREATH_MIN_PCT / 100;
    int breath_max_brightness = max_brightness * BREATH_MAX_PCT / 100;

    int inactivity_counter_ms = 0;
    int current_breath_max = breath_max_brightness;
    bool dimming = false;

    while (running) {
        bool key_pressed = check_keypress();
        if (key_pressed) {
            current_breath_max = breath_max_brightness;
            inactivity_counter_ms = 0;
            dimming = false;
        }

        // Breathing effect
        for (int i = min_brightness; i <= current_breath_max && running; i += DIM_STEP) {
            set_brightness(i);
            std::this_thread::sleep_for(std::chrono::milliseconds(DIM_INTERVAL_MS));
            inactivity_counter_ms += DIM_INTERVAL_MS;
            if (check_keypress()) {
                current_breath_max = breath_max_brightness;
                inactivity_counter_ms = 0;
                dimming = false;
                break;
            }
        }
        for (int i = current_breath_max; i >= min_brightness && running; i -= DIM_STEP) {
            set_brightness(i);
            std::this_thread::sleep_for(std::chrono::milliseconds(DIM_INTERVAL_MS));
            inactivity_counter_ms += DIM_INTERVAL_MS;
            if (check_keypress()) {
                current_breath_max = breath_max_brightness;
                inactivity_counter_ms = 0;
                dimming = false;
                break;
            }
        }

        if (!dimming && inactivity_counter_ms >= INACTIVITY_TIMEOUT_SEC * 1000) {
            dimming = true;
        }

        // Dimming effect
        if (dimming && current_breath_max > min_brightness) {
            for (int step = 0; step < DIMMING_STEPS && running && !check_keypress(); ++step) {
                current_breath_max -= (breath_max_brightness - min_brightness) / DIMMING_STEPS;
                if (current_breath_max < min_brightness) current_breath_max = min_brightness;
                std::this_thread::sleep_for(std::chrono::milliseconds(100));
            }
            if (current_breath_max <= min_brightness) {
                set_brightness(min_brightness);
            }
        }
    }

    set_brightness(min_brightness);
    restore_terminal(orig_term);
    return 0;
}