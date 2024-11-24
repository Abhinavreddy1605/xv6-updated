
# xv6 Kernel Modifications

This repository contains custom modifications to the xv6 operating system. The project focuses on the implementation of the following system calls and features:

1. **Message Passing (send/receive system calls)**
2. **`getppid()` system call**
3. **`ps` system call (process status)**
4. **Copy system call (`copy`)**

Each system call has been implemented with detailed modifications in the respective kernel files.

---

## Features Implemented

### 1. Message Passing (send/receive)
Message passing allows inter-process communication (IPC) using a message queue.

**Modified Files:**
- `msgqueue.h` (New)
- `sysproc.c`
- `syscall.h`
- `syscall.c`
- `user.h`
- `usys.S`

**Code Changes:**

#### `msgqueue.h` (New File)
```c
#ifndef MSGQUEUE_H
#define MSGQUEUE_H

#include "param.h"
#include "spinlock.h"

#define MAX_MESSAGES 64
#define MSG_SIZE 128

struct message {
    int type;
    char data[MSG_SIZE];
};

struct message_queue {
    struct spinlock lock;
    struct message messages[MAX_MESSAGES];
    int head;
    int tail;
    int count;
};

#endif
```

#### Changes in `sysproc.c`
```c
#include "msgqueue.h"

static struct message_queue msgq;

// Initialize the message queue
void msgqueue_init(void) {
    initlock(&msgq.lock, "msgqueue");
    msgq.head = 0;
    msgq.tail = 0;
    msgq.count = 0;
}

// `send` system call
int sys_send(void) {
    int type;
    char *msg;

    if (argint(0, &type) < 0 || argptr(1, &msg, MSG_SIZE) < 0) {
        return -1;
    }

    acquire(&msgq.lock);
    if (msgq.count == MAX_MESSAGES) {
        release(&msgq.lock);
        return -1;
    }

    msgq.messages[msgq.tail].type = type;
    safestrcpy(msgq.messages[msgq.tail].data, msg, MSG_SIZE);
    msgq.tail = (msgq.tail + 1) % MAX_MESSAGES;
    msgq.count++;
    release(&msgq.lock);
    return 0;
}

// `receive` system call
int sys_recv(void) {
    int type;
    char *msg;

    if (argint(0, &type) < 0 || argptr(1, &msg, MSG_SIZE) < 0) {
        return -1;
    }

    acquire(&msgq.lock);
    for (int i = 0; i < msgq.count; i++) {
        int index = (msgq.head + i) % MAX_MESSAGES;
        if (msgq.messages[index].type == type) {
            safestrcpy(msg, msgq.messages[index].data, MSG_SIZE);
            for (int j = index; j != msgq.tail; j = (j + 1) % MAX_MESSAGES) {
                msgq.messages[j] = msgq.messages[(j + 1) % MAX_MESSAGES];
            }
            msgq.tail = (msgq.tail - 1 + MAX_MESSAGES) % MAX_MESSAGES;
            msgq.count--;
            release(&msgq.lock);
            return 0;
        }
    }

    release(&msgq.lock);
    return -1;
}
```

#### Changes in `syscall.h`
```c
#define SYS_send 22
#define SYS_recv 23
```

#### Changes in `syscall.c`
```c
extern int sys_send(void);
extern int sys_recv(void);

[SYS_send] sys_send,
[SYS_recv] sys_recv,
```

#### Changes in `user.h`
```c
int send(int type, char *msg);
int recv(int type, char *msg);
```

#### Changes in `usys.S`
```asm
SYSCALL(send)
SYSCALL(recv)
```

---

### 2. `getppid` System Call
This system call retrieves the parent process ID of the current process.

**Modified Files:**
- `sysproc.c`
- `syscall.h`
- `syscall.c`
- `user.h`
- `usys.S`

**Code Changes:**

#### Changes in `sysproc.c`
```c
int sys_getppid(void) {
    return myproc()->parent->pid;
}
```

#### Changes in `syscall.h`
```c
#define SYS_getppid 24
```

#### Changes in `syscall.c`
```c
extern int sys_getppid(void);

[SYS_getppid] sys_getppid,
```

#### Changes in `user.h`
```c
int getppid(void);
```

#### Changes in `usys.S`
```asm
SYSCALL(getppid)
```

---

### 3. `ps` System Call (Process Status)
This system call lists all processes and their states.

**Modified Files:**
- `proc.c`
- `syscall.h`
- `syscall.c`
- `user.h`
- `usys.S`

**Code Changes:**

#### Changes in `proc.c`
```c
int sys_ps(void) {
    struct proc *p;
    acquire(&ptable.lock);
    cprintf("PID	State		Name
");
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state != UNUSED) {
            cprintf("%d	%s	%s
", p->pid, states[p->state], p->name);
        }
    }
    release(&ptable.lock);
    return 0;
}
```

#### Changes in `syscall.h`
```c
#define SYS_ps 25
```

#### Changes in `syscall.c`
```c
extern int sys_ps(void);

[SYS_ps] sys_ps,
```

#### Changes in `user.h`
```c
int ps(void);
```

#### Changes in `usys.S`
```asm
SYSCALL(ps)
```

---

### 4. Copy System Call
The `copy` system call copies the contents of one file to another.

**Modified Files:**
- `sysfile.c`
- `syscall.h`
- `syscall.c`
- `user.h`
- `usys.S`

**Code Changes:**

#### Changes in `sysfile.c`
```c
int sys_copy(void) {
    char *src, *dst;

    if (argstr(0, &src) < 0 || argstr(1, &dst) < 0) {
        return -1;
    }

    struct file *src_file = fileopen(src, O_RDONLY);
    struct file *dst_file = fileopen(dst, O_CREATE | O_WRONLY);
    char buffer[512];
    int n;

    while ((n = fileread(src_file, buffer, sizeof(buffer))) > 0) {
        filewrite(dst_file, buffer, n);
    }

    fileclose(src_file);
    fileclose(dst_file);
    return 0;
}
```

#### Changes in `syscall.h`
```c
#define SYS_copy 26
```

#### Changes in `syscall.c`
```c
extern int sys_copy(void);

[SYS_copy] sys_copy,
```

#### Changes in `user.h`
```c
int copy(char *src, char *dst);
```

#### Changes in `usys.S`
```asm
SYSCALL(copy)
```

---

### Compilation Instructions

1. Clone the xv6 repository and navigate to the directory.
2. Apply the changes to the respective files as listed above.
3. Build the kernel using:
   ```bash
   make clean && make qemu
   ```

---

## Examples

### Testing `send` and `recv`
Run two processes to send and receive messages.

### Testing `getppid`
Run a program to display the parent process ID.

### Testing `ps`
Run the `ps` command to list all processes.

### Testing `copy`
Use the `copy` command to duplicate a file:
```bash
copy source.txt destination.txt
```

---

## Credits
This project was developed as a learning exercise for understanding xv6 and operating system internals.
