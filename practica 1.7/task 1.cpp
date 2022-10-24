#include <iostream>

int main() {
    int x, y;

    std::cout<<"Input a: \n";
    std::cin>>x;

    std::cout<<"Input b: \n";
    std::cin>>y;

    if(x>y)
    {std::cout<<"a > b \n";}

    else if(x<y)
    {std::cout<<"a < b \n";}

    else
    {std::cout<<"a = b \n";}    

    return 0;
}