#include <stdio.h>
#include <string.h>
#include <math.h>

// main.c
// author: Seong Yong-ju <sei40kr@gmail.com>

int main(int argc, char *argv[]) {
  int n, a, b;
  scanf("%d %d %d", &n, &a, &b);

  int t = n * a;
  printf("%d\n", b < t ? b : t);

  return 0;
}
