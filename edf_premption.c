#include <stdio.h>
#include <stdlib.h>

#define MAX_PROCESSES 100

typedef struct {
    int id;
    int execution_time;
    int deadline;
    int arrival_time;
    int remaining_time;
    int period;
    int next_deadline;
    double utilization; // Utilization factor for each process
} Process;

// Function to sort processes by their next deadline (ascending order)
void sort_by_deadline(Process processes[], int n) {
    for (int i = 0; i < n - 1; i++) {
        for (int j = i + 1; j < n; j++) {
            if (processes[i].next_deadline > processes[j].next_deadline) {
                Process temp = processes[i];
                processes[i] = processes[j];
                processes[j] = temp;
            }
        }
    }
}

void edf_scheduling(Process processes[], int n, int total_time) {
    int time = 0;
    int waiting_time = 0;
    int turnaround_time = 0;
    int cpu_busy_time = 0;  // Track the total busy time of the CPU

    for (int i = 0; i < n; i++) {
        processes[i].next_deadline = processes[i].deadline;
    }

    while (time < total_time) {
        sort_by_deadline(processes, n); // Sort processes by their next deadlines

        int executed = 0;
        for (int i = 0; i < n; i++) {
            if (processes[i].arrival_time <= time && processes[i].remaining_time > 0) {
                // Execute the task for 1 time unit (preemptive execution)
                processes[i].remaining_time -= 1;
                time += 1;
                cpu_busy_time += 1;  // Increment CPU busy time

                printf("Process %d executed for 1 unit, Total time: %d, Remaining time: %d\n", 
                       processes[i].id, time, processes[i].remaining_time);

                if (processes[i].remaining_time == 0) {
                    // Calculate waiting and turnaround times for completed processes
                    waiting_time += time - processes[i].arrival_time - processes[i].execution_time;
                    turnaround_time += time - processes[i].arrival_time;

                    printf("Process %d completed at time %d\n", processes[i].id, time);

                    // Set up for the next period
                    processes[i].arrival_time += processes[i].period;
                    processes[i].next_deadline += processes[i].period;
                    processes[i].remaining_time = processes[i].execution_time;
                }

                executed = 1;
                break;  // Break to re-evaluate the next task with the earliest deadline
            }
        }

        if (!executed) {
            time++;  // If no process was executed, increment time
        }
    }

    // Calculate CPU utilization as a percentage
    float cpu_utilization = ((float)cpu_busy_time / total_time) * 100;
    
    printf("Average Waiting Time: %.2f\n", (float)waiting_time / n);
    printf("Average Turnaround Time: %.2f\n", (float)turnaround_time / n);
    printf("CPU Utilization: %.2f%%\n", cpu_utilization);
}

int main() {
    Process processes[MAX_PROCESSES];
    int n, total_time;
    double total_utilization = 0.0;

    printf("Enter the number of processes: ");
    scanf("%d", &n);

    if (n > MAX_PROCESSES) {
        printf("Number of processes exceeds the maximum limit of %d.\n", MAX_PROCESSES);
        return 1;
    }

    printf("Enter the total time for simulation: ");
    scanf("%d", &total_time);

    for (int i = 0; i < n; i++) {
        processes[i].id = i + 1;
        
        printf("Enter execution time for process %d: ", processes[i].id);
        scanf("%d", &processes[i].execution_time);
        
        printf("Enter deadline for process %d: ", processes[i].id);
        scanf("%d", &processes[i].deadline);
        
        printf("Enter arrival time for process %d: ", processes[i].id);
        scanf("%d", &processes[i].arrival_time);
        
        printf("Enter period for process %d: ", processes[i].id);
        scanf("%d", &processes[i].period);
        
        // Initialize remaining_time and next_deadline for each process
        processes[i].remaining_time = processes[i].execution_time;
        processes[i].next_deadline = processes[i].deadline;

        // Calculate utilization factor u_i = execution_time / period
        processes[i].utilization = (double)processes[i].execution_time / processes[i].period;
        total_utilization += processes[i].utilization;
    }

    // Display total utilization and check if it meets the necessary condition
    printf("\nTotal Utilization (U) = ");
    for (int i = 0; i < n; i++) {
        printf("%.2f", processes[i].utilization);
        if (i < n - 1) {
            printf(" + ");
        }
    }
    printf(" = %.2f\n", total_utilization);

    if (total_utilization <= 1.0) {
        printf("The necessary condition for EDF scheduling is met (U ≤ 1).\n");
    } else {
        printf("Warning: The necessary condition for EDF scheduling is NOT met (U > 1).\n");
        printf("The task set may not be schedulable under EDF.\n");
        return 0;
    }

    edf_scheduling(processes, n, total_time);
    
    return 0;
}
