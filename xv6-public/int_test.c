#include "user.h"

// Handler function for SIGINT (triggered by Shift+C)
void sigint_handler(void) {
    printf(1, "Caught SIGINT (Shift+C)! Exiting...\n");
    exit();
}

int main() {
    // Register the SIGINT handler for signal number 2
    signal(2, sigint_handler);

    // Infinite loop with periodic output
    while (1) {
        printf(1, "Running... Press Shift+C to send SIGINT\n");
        sleep(100);  // Sleep for a while to avoid spamming output
    }
    return 0;
}
