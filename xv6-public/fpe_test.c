#include "user.h"

void sigfpe_handler(void) {
    printf(1, "Caught SIGFPE: Division by zero error handled.\n");
    exit();  // Exit the process gracefully
}

int main() {
    signal(8, sigfpe_handler);  // Register SIGFPE handler

    // Trigger a division by zero
    int x = 1, y = 0;
    printf(1, "Result: %d\n", x / y);

    printf(1, "This should not print.\n");
    exit();
}
