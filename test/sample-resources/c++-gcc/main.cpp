#include <iostream>
#include <cstdlib>

// main.cpp
// author: Seong Yong-ju <sei40kr@gmail.com>

using namespace std;

int main() {
  ios_base::sync_with_stdio(false);
  cin.tie(NULL);

  int n, a, b;
  cin >> n;
  cin >> a;
  cin >> b;

  int t = n * a;
  cout << (b < t ? b : t) << endl;

  return 0;
}
