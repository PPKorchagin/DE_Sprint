#include <iostream>
#include <string>
using namespace std;

int main() {
    string line;
    cout << "input a numbers separated by space: ";
    getline(cin, line);

    int max=-1;
    int pos;
    while ((pos=line.find(" "))!=std::string::npos) {
        int n=stoi(line.substr(0,pos));
        if (n>max) {
            max=n;
        }

        line = line.substr(pos+1,line.length()-pos);
    }
    std::cout << "Max: " << max;
    return 0;
}