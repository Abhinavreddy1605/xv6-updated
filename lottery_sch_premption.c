#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>  // For sleep function (simulate time slice)

#define MAX_TASKS 10
#define TIME_SLICE 1  // Time slice in seconds

typedef struct {
    int id;
    int burst_time;
    int remaining_time;
    int tickets;
    int ticket_start;  // Start of ticket range
    int ticket_end;    // End of ticket range
} Task;

// Function to allocate ticket ranges to each task based on their tickets
void allocate_ticket_ranges(Task tasks[], int n) {
    int ticket_counter = 1;
    for (int i = 0; i < n; i++) {
        if (tasks[i].remaining_time > 0) {  // Only assign ranges to incomplete tasks
            tasks[i].ticket_start = ticket_counter;
            tasks[i].ticket_end = ticket_counter + tasks[i].tickets - 1;
            ticket_counter += tasks[i].tickets;
        } else {
            tasks[i].ticket_start = tasks[i].ticket_end = 0;  // Mark completed tasks with no range
        }
    }
}

// Function to calculate the total number of tickets in the system
int calculate_total_tickets(Task tasks[], int n) {
    int total_tickets = 0;
    for (int i = 0; i < n; i++) {
        if (tasks[i].remaining_time > 0) {  // Only count tickets for incomplete tasks
            total_tickets += tasks[i].tickets;
        }
    }
    return total_tickets;
}

// Function to pick a winning ticket
int pick_winning_ticket(int total_tickets) {
    return rand() % total_tickets + 1;
}

// Function to perform preemptive lottery scheduling
void lottery_scheduling(Task tasks[], int n) {
    int total_tickets = calculate_total_tickets(tasks, n);
    int time = 0;

    while (1) {
        int all_tasks_completed = 1;

        // Check if there are tickets left to draw from
        if (total_tickets <= 0) {
            printf("All tasks completed by time %d.\n", time);
            break;
        }

        // Allocate ranges based on current tickets and update total tickets
        allocate_ticket_ranges(tasks, n);

        // Pick a winning ticket at each time slice
        int winning_ticket = pick_winning_ticket(total_tickets);
        printf("Winning ticket is %d (Total Tickets: %d)\n", winning_ticket, total_tickets);  //line to show the generated ticket
        int ticket_counter = 0;

        for (int i = 0; i < n; i++) {
            if (tasks[i].remaining_time > 0) {
                all_tasks_completed = 0;

                // Check if this task's ticket range includes the winning ticket
                if (winning_ticket >= tasks[i].ticket_start && winning_ticket <= tasks[i].ticket_end) {
                    // Execute the chosen task for one time slice
                    printf("Time %d: Task %d is executing (Tickets: %d, Range: %d-%d)\n",
                           time, tasks[i].id, tasks[i].tickets, tasks[i].ticket_start, tasks[i].ticket_end);
                    tasks[i].remaining_time -= TIME_SLICE;
                    time += TIME_SLICE;

                    // Simulate time slice
                    sleep(TIME_SLICE);

                    // Check if the task has completed
                    if (tasks[i].remaining_time <= 0) {
                        printf("Time %d: Task %d has completed\n", time, tasks[i].id);
                        total_tickets -= tasks[i].tickets;  // Adjust total tickets
                        tasks[i].tickets = 0;  // Remove tickets for completed task
                    }
                    break;  // Draw a new lottery for the next time slice
                }
            }
        }

        // Recalculate total tickets in case any task has completed
        total_tickets = calculate_total_tickets(tasks, n);

        // Check if all tasks are completed
        if (all_tasks_completed) {
            printf("All tasks completed by time %d.\n", time);
            break;
        }
    }
}

int main() {
    srand(time(0));  // Seed for random ticket selection

    Task tasks[MAX_TASKS];
    int n;

    printf("Enter number of tasks: ");
    scanf("%d", &n);

    for (int i = 0; i < n; i++) {
        tasks[i].id = i + 1;
        printf("Enter burst time for Task %d: ", tasks[i].id);
        scanf("%d", &tasks[i].burst_time);
        tasks[i].remaining_time = tasks[i].burst_time;

        printf("Enter number of tickets for Task %d: ", tasks[i].id);
        scanf("%d", &tasks[i].tickets);
    }

    printf("\nStarting Preemptive Lottery Scheduling...\n");
    lottery_scheduling(tasks, n);

    return 0;
}
