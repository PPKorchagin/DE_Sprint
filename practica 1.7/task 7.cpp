#include <iostream>
using namespace std;

int main() {

    float i;
    for (i=-4;i<=4;i+=0.5) {
        cout << i << ": " << -2*i*i-5*i - 8 << endl;
    }

    return 0;
}

