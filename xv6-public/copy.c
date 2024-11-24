#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf(2, "Usage: copy <source> <destination>\n");
        exit();
    }

    if (copy(argv[1], argv[2]) < 0) {
        printf(2, "Copy failed\n");
        exit();
    }

    printf(1, "Copy successful\n");
    exit();
}
