#include <iostream>

int main() {
    
    int user_number;

    std::cout<<"Enter num \n";
    std::cin>>user_number;

    int res = (user_number)%2;

    if(res==0)
    {
        std::cout<<"Num is even \n";
    }

    else
    {
        std::cout<<"Num is odd \n";
    }    

    return 0;
}