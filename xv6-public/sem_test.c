#include "types.h"
#include "stat.h"
#include "user.h"

#define SEM_ID 0

void child_process() {
    for (int i = 0; i < 5; i++) {
        sem_wait(SEM_ID);
        printf(1, "Child: Acquired semaphore\n");
        sleep(50);  // Simulate work
        sem_post(SEM_ID);
        printf(1, "Child: Released semaphore\n");
    }
    exit();
}

int main() {
    sem_init(SEM_ID, 1);

    if (fork() == 0) {
        child_process();
    } else {
        for (int i = 0; i < 5; i++) {
            sem_wait(SEM_ID);
            printf(1, "Parent: Acquired semaphore\n");
            sleep(50);  // Simulate work
            sem_post(SEM_ID);
            printf(1, "Parent: Released semaphore\n");
        }
        wait();
    }
    exit();
}
