#include "types.h"
#include "stat.h"
#include "user.h"
#include "msgqueue.h"

#define MSG_TYPE 1
#define MSG "Message from sender!"

int main() {
    if (send(MSG_TYPE, MSG) < 0) {
        printf(1, "Sender: Failed to send message\n");
    } else {
        printf(1, "Sender: Message sent: %s\n", MSG);
    }
    exit();
}
