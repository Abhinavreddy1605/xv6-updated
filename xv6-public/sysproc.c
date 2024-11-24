#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "msgqueue.h"  // Include message queue header
#include "semaphore.h"
#include "console.h"

static void *shared_memory = 0;
// VGA memory location
#define VGA_MEMORY 0xB8000
#define SCREEN_WIDTH 80
#define SCREEN_HEIGHT 25
int sys_fork(void) {
    return fork();
}

int sys_exit(void) {
    exit();
    return 0;  // not reached
}

int sys_wait(void) {
    return wait();
}

int sys_kill(void) {
    int pid;

    if (argint(0, &pid) < 0)
        return -1;
    return kill(pid);
}

int sys_getpid(void) {
    return myproc()->pid;
}

int sys_sbrk(void) {
    int addr;
    int n;

    if (argint(0, &n) < 0)
        return -1;
    addr = myproc()->sz;
    if (growproc(n) < 0)
        return -1;
    return addr;
}

int sys_sleep(void) {
    int n;
    uint ticks0;

    if (argint(0, &n) < 0)
        return -1;
    acquire(&tickslock);
    ticks0 = ticks;
    while (ticks - ticks0 < n) {
        if (myproc()->killed) {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    }
    release(&tickslock);
    return 0;
}

int sys_uptime(void) {
    uint xticks;

    acquire(&tickslock);
    xticks = ticks;
    release(&tickslock);
    return xticks;
}

int sys_getppid(void) {
    return myproc()->parent->pid;
}

// Shared memory allocation
int sys_shmget(void) {
    if (!shared_memory) {
        shared_memory = kalloc();
        if (!shared_memory) {
            cprintf("sys_shmget: kalloc failed\n");
            return -1; // Memory allocation failed
        }
        memset(shared_memory, 0, PGSIZE);
    }

    if (mappages(myproc()->pgdir, (void *)SHMEM, PGSIZE, V2P(shared_memory), PTE_W | PTE_U) < 0) {
        cprintf("sys_shmget: mappages failed\n");
        return -1; // Mapping failed
    }

    return SHMEM; // Success
}

// Free shared memory
int sys_shmrem(void) {
    if (!shared_memory)
        return -1;  // Shared memory is not allocated

    kfree(shared_memory);
    shared_memory = 0;

    return 0;  // Success
}

// Signal handling
int sys_signal(void) {
    int signum;
    void (*handler)(void);

    if (argint(0, &signum) < 0 || argptr(1, (void *)&handler, sizeof(void *)) < 0) {
        return -1;
    }

    if (signum < 0 || signum >= NUMSIGNALS) {
        return -1;  // Invalid signal number
    }

    myproc()->signal_handlers[signum] = handler;  // Set the handler
    return 0;
}

// Send message to the queue
int sys_send(void) {
    int type;
    char *msg;

    // Retrieve arguments from user space
    if (argint(0, &type) < 0 || argptr(1, &msg, MSG_SIZE) < 0) {
        return -1;  // Invalid arguments
    }

    acquire(&msgq.lock);

    // Check if the queue is full
    if (msgq.count == MAX_MESSAGES) {
        release(&msgq.lock);
        return -1;  // Queue is full
    }

    // Add the message to the queue
    msgq.messages[msgq.tail].type = type;
    safestrcpy(msgq.messages[msgq.tail].data, msg, MSG_SIZE);
    msgq.tail = (msgq.tail + 1) % MAX_MESSAGES;
    msgq.count++;

    release(&msgq.lock);
    return 0;  // Success
}

// Receive message from the queue
int sys_recv(void) {
    int type;
    char *msg;

    // Retrieve arguments from user space
    if (argint(0, &type) < 0 || argptr(1, &msg, MSG_SIZE) < 0) {
        return -1;  // Invalid arguments
    }

    acquire(&msgq.lock);

    // Search for a message with the specified type
    for (int i = 0; i < msgq.count; i++) {
        int index = (msgq.head + i) % MAX_MESSAGES;
        if (msgq.messages[index].type == type) {
            // Copy the message to user space
            safestrcpy(msg, msgq.messages[index].data, MSG_SIZE);

            // Remove the message from the queue
            for (int j = index; j != msgq.tail; j = (j + 1) % MAX_MESSAGES) {
                msgq.messages[j] = msgq.messages[(j + 1) % MAX_MESSAGES];
            }
            msgq.tail = (msgq.tail - 1 + MAX_MESSAGES) % MAX_MESSAGES;
            msgq.count--;

            release(&msgq.lock);
            return 0;  // Success
        }
    }

    release(&msgq.lock);
    return -1;  // No message of the specified type
}


int sys_clear_console(void) {
    consoleclear();  // Clear the console
    return 0;        // Return success
}


int sys_ps(void) {
  procdump();  // Call the procdump function
  return 0;    // Success
}