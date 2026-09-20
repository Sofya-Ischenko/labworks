#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define DEFAULT_N 15216685603L
#define PI_TARGET 3.141592653589793

double leibniz_calculation_of_pi(long n) {
    double sum = 0.0;
    double sign = 1.0;

    for (long i = 0; i < n; i++) {
        double denominator = 2.0 * (double)i + 1.0;
        sum += sign * 4.0 / denominator;
        sign = -sign;
    }

    return sum;
}


int main(int argc, char *argv[]) {
    long n = DEFAULT_N;

    if (argc > 1) {
        n = atol(argv[1]);      
        if (n <= 0) {
            fprintf(stderr, "Error: N must be positive\n");
            return 1;
        }
    }

    double pi = leibniz_calculation_of_pi(n);
    double error = fabs(pi - PI_TARGET);

    printf("N = %ld\n", n);
    printf("Pi = %.15f\n", pi);
    printf("Error = %.15f\n", error);

    return 0;
} 

