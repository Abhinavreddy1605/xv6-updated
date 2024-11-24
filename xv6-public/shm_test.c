#include "user.h"

int main() {
    char *shm = shmget();  // Get shared memory
    if (!shm) {
        printf(1, "Failed to allocate shared memory\n");
        exit();
    }

    printf(1, "Shared memory address: %p\n", shm);

    // Write to shared memory
    strcpy(shm, "Hello from shared memory!");
    printf(1, "Shared memory content: %s\n", shm);

    // Release shared memory
    if (shmrem() == 0) {
        printf(1, "Shared memory released successfully\n");
    } else {
        printf(1, "Failed to release shared memory\n");
    }

    exit();
}
