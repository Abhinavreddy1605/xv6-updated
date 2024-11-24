#ifndef MSGQUEUE_H
#define MSGQUEUE_H

#include "spinlock.h"  // Include the definition for spinlock

#define MAX_MESSAGES 64    // Maximum number of messages in the queue
#define MSG_SIZE 32        // Maximum size of each message

// A single message structure
struct message {
    int type;             // Message type or tag
    char data[MSG_SIZE];  // Message content
};

// A global message queue structure
struct message_queue {
    struct spinlock lock;               // Protects the queue
    struct message messages[MAX_MESSAGES]; // Array of messages
    int head;                           // Read pointer
    int tail;                           // Write pointer
    int count;                          // Number of messages in the queue
};

// Declare the global message queue
extern struct message_queue msgq;

#endif
