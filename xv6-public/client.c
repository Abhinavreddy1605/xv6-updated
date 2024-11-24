#include "types.h"
#include "stat.h"
#include "user.h"
#include "msgqueue.h"

#define MSG_TYPE 1

int main() {
    char buf[MSG_SIZE];

    if (recv(MSG_TYPE, buf) < 0) {
        printf(1, "Receiver: No message found for type %d\n", MSG_TYPE);
    } else {
        printf(1, "Message received: %s parent id %d\n", buf,getppid());
    }
    exit();
}
