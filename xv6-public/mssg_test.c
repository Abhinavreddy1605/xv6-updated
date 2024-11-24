#include "types.h"
#include "stat.h"
#include "user.h"
#include "msgqueue.h"

#define MSG_TYPE 1
#define MSG "Hello mssg passing done hurry !"

int main() {
    char buf[MSG_SIZE];

    int pid = fork();
    if (pid == 0) {
        // Child process
        sleep(100); // Ensure parent sends the message first
        if (recv(MSG_TYPE, buf) < 0) {
            printf(1, "Child: No message found\n");
        } else {
            printf(1, "Child received: %s\n", buf);
        }
        exit();
    } else if (pid > 0) {
        // Parent process
        if (send(MSG_TYPE, MSG) < 0) {
            printf(1, "Parent: Failed to send message\n");
        } else {
            printf(1, "Parent sent: %s\n", MSG);
        }
        wait();
    } else {
        printf(1, "Fork failed\n");
    }
    exit();
}
