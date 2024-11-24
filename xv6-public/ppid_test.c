#include "user.h"
#include "types.h"

int main() {
    printf(1, "My PID: %d\n", getpid());
    printf(1, "Parent PID: %d\n", getppid());

    int pid = fork();
    if (pid == 0) {
        // Child process
        printf(1, "Child PID: %d, Parent PID: %d\n", getpid(), getppid());
        exit();  // Exit the child process
    } else {
        // Parent process
        wait();  // Wait for the child process to finish
    }

    exit();  // Exit the parent process
}
