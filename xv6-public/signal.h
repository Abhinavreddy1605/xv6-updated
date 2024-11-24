#ifndef SIGNAL_H
#define SIGNAL_H

#define SIGKILL  1  // Kill process
#define SIGSTOP  2  // Stop process
#define SIGUSR1  3  // User-defined signal

typedef void (*sighandler_t)(int);

#endif
