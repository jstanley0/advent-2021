#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_INPUT 8192
#define MAX_CRABS 2048

int main(int argc, char **argv)
{
    char input[MAX_INPUT];
    FILE *f = fopen(argv[1], "r");
    size_t sz = fread(input, 1, MAX_INPUT - 1, f);
    input[sz] = '\0';
    fclose(f);

    int crabs[MAX_CRABS];
    size_t nCrabs = 0;

    char *n = strtok(input, ",");
    do {
       crabs[nCrabs++] = atoi(n);
       n = strtok(NULL, ",");
    } while(n && nCrabs < MAX_CRABS);

    int c = crabs[0];
    for(size_t n = 1; n < nCrabs; ++n) {
        if (crabs[n] < c)
            c = crabs[n];
    }

    int best_cost = -1;
    for(;;) {
        int cost = 0;
        for(size_t i = 0; i < nCrabs; ++i) {
            int d = crabs[i] - c;
            if (d < 0) d = -d;
            cost += (d * (1 + d)) / 2;
        }
        if (best_cost < 0 || cost < best_cost)
            best_cost = cost;
        else
            break;
        c += 1;
    }

    printf("%d\n", best_cost);
    return 0;
}
