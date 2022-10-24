#include <iostream>

int main() {
    
    int basic_year=2024;
    int user_year;

    std::cout<<"Enter the year and find out if it is a leap year \n";
    std::cin>>user_year;

    int diff = abs((basic_year - user_year)%4);

    if(diff==0)
    {std::cout<<"Yes \n";}

    else
    {std::cout<<"No \n";}    

    return 0;
}