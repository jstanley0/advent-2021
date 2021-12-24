#include <stdio.h>

int A[14] = {12, 13, 13, -2, -10, 13, -14, -5, 15, 15, -14, 10, -14, -5};
int B[14] = {1, 1, 1, 26, 26, 1, 26, 26, 1, 1, 26, 1, 26, 26};
int C[14] = {7, 8, 10, 4, 4, 6, 11, 13, 1, 8, 4, 13, 4, 14};

// built out of B. a z value greater than or equal to this can't possibly reach 0 by the end
long long max_z[14] = {8031810176, 8031810176, 8031810176, 8031810176, 308915776, 11881376, 11881376, 456976, 17576, 17576, 17576, 676, 676, 26};

long long stage(int n, int w, long long z)
{
  if (z % 26 + A[n] == w) {
    return z / B[n];
  } else {
    return 26 * (z / B[n]) + w + C[n];
  }
}

void search(int depth, long long z, char solution[15])
{
    if (depth == 14) {
        if (z == 0) {
            solution[depth] = '\0';
            printf("%s\n", solution);
        }
        return;
    }
    else if (z >= max_z[depth])
        return;

    for(int i = 1; i <= 9; ++i) {
        solution[depth] = '0' + i;
        search(depth + 1, stage(depth, i, z), solution);
    }
}

int main(int argc, char **argv)
{
    char solution[15];
    search(0, 0, solution);
}
