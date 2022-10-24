#include <iostream>
#include <string>
#include <time.h>
#include <algorithm>
using namespace std;

struct train_struct {
    string destination;
    int train_num;
    long time;
};

int main() {
    train_struct *trains = new train_struct[5];

    train_struct train0= {"Stavropol",703,9*60+25,};
    trains[0]=train0;
    train_struct train1={"Gelendzhik",265,19*60+30,};
    trains[1]=train1;
    train_struct train2={"Pyatigorsk",68,8*60+45,};
    trains[2]=train2;
    train_struct train3={"Kislovodsk",736,15*60+15,};
    trains[3]=train3;
    train_struct train4={"Pyatigorsk",68,17*60+30,};
    trains[4]=train4;

    cout << "Input train num: ";
    string train_n_s;
    getline(cin,train_n_s);
    int train_n=stoi(train_n_s);

    int i;
    bool found=false;
    for (i=0;i<5;i++) {
        if (trains[i].train_num==train_n) {
            found=true;
            cout << "Found train #" << train_n << " with destination " << trains[i].destination << ", " << trains[i].time/60 << ":" << trains[i].time%60 << endl;
            break;
        }
    }
    if (!found) {
        cout << "No train with num #" << train_n << endl;
    }


    int msorts[5];
    for (i=0;i<5;i++) {
        msorts[i]=i;
    }

    int j;
    for (j=0;j<4;j++) {
        for (i=0;i<4;i++) {
            bool cmp=trains[msorts[i]].destination>trains[msorts[i+1]].destination;
            if (cmp) {
                int tmppos;
                tmppos=msorts[i];
                msorts[i]=msorts[i+1];
                msorts[i+1]=tmppos;
            }else if (!cmp && trains[msorts[i]].train_num<trains[msorts[i+1]].train_num) {
                int tmppos;
                tmppos=msorts[i];
                msorts[i]=msorts[i+1];
                msorts[i+1]=tmppos;
            }
        }
    }

    cout << "Orig:" << endl;
    for (i=0;i<5;i++) {
        train_struct tr=trains[i];
        cout << "#" << tr.train_num << " to " << tr.destination << ", " << tr.time/60 << ":" << tr.time%60 << endl;
    }

    cout << "\nSorted:" << endl;
    for (i=0;i<5;i++) {
        train_struct tr=trains[msorts[i]];
        cout << "#" << tr.train_num << " to " << tr.destination << ", " << tr.time/60 << ":" << tr.time%60 << endl;
    }
}