#include <stdio.h>

int add_numbers(int a, int b)
{
    return a + b;
}

int main()
{
    int result = add_numbers(5, 7);
    printf("The result is: %d\n", result);
    return 0;
}