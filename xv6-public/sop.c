// ps.c
#include "types.h"
#include "stat.h"
#include "user.h"

int main(void) {
  printf(1, "PID\tPPID\tSTATE\t\tNAME\n");
  ps();  // Call the `ps` system call
  exit();
}
