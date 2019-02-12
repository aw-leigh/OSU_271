#include <iostream>

using std::cin;
using std::cout;
using std::endl;

int main()
{
    int primeArray[10] = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29};

    int numberOfNumbers = 0;
    int i = 0;
    cin >> numberOfNumbers;


    while (i <= numberOfNumbers-1) {
        if (num%i==0) 
        {
            printf("%d is composite\n\n",num);
            return; // test is finished
        }
        i++;   // increase i by 1
    }
    printf("%d is prime number\n", num);


    return 0;
}