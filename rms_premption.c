#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define MAX_PROCESSES 100

typedef struct {
    int id;
    int execution_time;
    int period;
    int arrival_time;
    int remaining_time;
    int next_arrival_time;
} Process;

// Function to sort processes by their period (ascending order, fixed priority)
void sort_by_period(Process processes[], int n) {
    for (int i = 0; i < n - 1; i++) {
        for (int j = i + 1; j < n; j++) {
            if (processes[i].period > processes[j].period) {
                Process temp = processes[i];
                processes[i] = processes[j];
                processes[j] = temp;
            }
        }
    }
}

// Function to display the priority order based on period
void display_priority_order(Process processes[], int n) {
    printf("\nPriority Order of Processes (Higher priority to lower):\n");
    for (int i = 0; i < n; i++) {
        printf("Priority %d -> Process %d (Period: %d)\n", i + 1, processes[i].id, processes[i].period);
    }
    printf("\n");
}

// Check RMS schedulability condition
int check_rms_schedulability(Process processes[], int n) {
    float total_utilization = 0.0;
    float x = n * (pow(2, 1.0 / (float)n) - 1);

    for (int i = 0; i < n; i++) {
        float utilization = (float)processes[i].execution_time / processes[i].period;
        total_utilization += utilization;
    }

    printf("\nTotal CPU Utilization: %.2f\n", total_utilization);
    if (total_utilization > x) {
        printf("The system is not schedulable under Rate Monotonic Scheduling as total utilization exceeds 1.\n");
        return 0;  // Not schedulable
    } else {
        printf("The system is schedulable under Rate Monotonic Scheduling.\n");
        return 1;  // Schedulable
    }
}

void rms_scheduling(Process processes[], int n, int total_time) {
    int time = 0;
    int waiting_time = 0;
    int turnaround_time = 0;
    int cpu_busy_time = 0;  // Track the total busy time of the CPU

    // Initialize next_arrival_time for each process
    for (int i = 0; i < n; i++) {
        processes[i].next_arrival_time = processes[i].arrival_time;
        processes[i].remaining_time = processes[i].execution_time;
    }

    sort_by_period(processes, n); // Sort processes by period to set fixed priorities
    display_priority_order(processes, n);  // Display the priority order

    while (time < total_time) {
        int executed = 0;

        for (int i = 0; i < n; i++) {
            // Check if the process is ready to execute
            if (processes[i].next_arrival_time <= time && processes[i].remaining_time > 0) {
                // Execute the task for 1 time unit (preemptive execution)
                processes[i].remaining_time -= 1;
                time += 1;
                cpu_busy_time += 1;  // Increment CPU busy time

                printf("Process %d executed for 1 unit, Total time: %d, Remaining time: %d\n", 
                       processes[i].id, time, processes[i].remaining_time);

                if (processes[i].remaining_time == 0) {
                    // Task completed, calculate waiting and turnaround time
                    waiting_time += time - processes[i].next_arrival_time - processes[i].execution_time;
                    turnaround_time += time - processes[i].next_arrival_time;

                    printf("Process %d completed at time %d\n", processes[i].id, time);

                    // Set up for the next period
                    processes[i].next_arrival_time += processes[i].period;
                    processes[i].remaining_time = processes[i].execution_time;
                }

                executed = 1;
                break;  // Preemptive: break to re-evaluate the highest priority task
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
    printf("CPU Utilization during scheduling: %.2f%%\n", cpu_utilization);
}

// Main function with input prompts
int main() {
    Process processes[MAX_PROCESSES];
    int n, total_time;

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
        
        printf("Enter period for process %d: ", processes[i].id);
        scanf("%d", &processes[i].period);
        
        printf("Enter arrival time for process %d: ", processes[i].id);
        scanf("%d", &processes[i].arrival_time);
        
        // Initialize remaining_time and next_arrival_time for each process
        processes[i].remaining_time = processes[i].execution_time;
        processes[i].next_arrival_time = processes[i].arrival_time;
    }

    // Check RMS schedulability before running the scheduling
    if (check_rms_schedulability(processes, n)) {
        rms_scheduling(processes, n, total_time);
    } else {
        printf("Cannot proceed with scheduling as the system does not meet RMS schedulability criteria.\n");
    }

    return 0;
}
