#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
  int i;

  for (i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  lidt(idt, sizeof(idt));
}

void
trap(struct trapframe *tf)
{
  if (tf->trapno == T_SYSCALL) {
    if (myproc() && myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if (myproc() && myproc()->killed)
      exit();
    return;
  }

  switch (tf->trapno) {
  case T_IRQ0 + IRQ_TIMER:
    if (cpuid() == 0) {
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE + 1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();

    // Handle SIGINT triggered by Shift+C
    if (myproc()) {
      myproc()->pending_signals |= (1 << 2);  // Raise SIGINT (signal number 2)
      cprintf("SIGINT triggered by Shift+C for process %d\n", myproc()->pid);
    }

    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_DIVIDE:
    // Handle SIGFPE (Division by Zero)
    if (myproc()) {
      myproc()->pending_signals |= (1 << 8);  // Raise SIGFPE (signal number 8)
      cprintf("SIGFPE triggered for process %d\n", myproc()->pid);
    }
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;

  default:
    if (myproc() == 0 || (tf->cs & 3) == 0) {
      // In kernel mode, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  // Deliver pending signals to the process if applicable.
  if (myproc() && myproc()->pending_signals) {
    for (int i = 0; i < NUMSIGNALS; i++) {
      if (myproc()->pending_signals & (1 << i)) {
        myproc()->pending_signals &= ~(1 << i);  // Clear the signal bit

        if (myproc()->signal_handlers[i]) {
          // Invoke the registered signal handler
          void (*handler)(void) = myproc()->signal_handlers[i];
          myproc()->signal_handlers[i] = 0;  // Reset to default
          handler();
        } else if (i == 2) {  // Default behavior for SIGINT
          cprintf("SIGINT received (Shift+C): terminating process %d\n", myproc()->pid);
          myproc()->killed = 1;  // Mark the process as killed
        } else if (i == 8) {  // Default behavior for SIGFPE
          cprintf("SIGFPE received: terminating process %d\n", myproc()->pid);
          myproc()->killed = 1;  // Mark the process as killed
        }
      }
    }
  }

  // Force process exit if it has been killed and is in user space.
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  if (myproc() && myproc()->state == RUNNING &&
      tf->trapno == T_IRQ0 + IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
    exit();
}
