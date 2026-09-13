#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define DEFAULT_N 15216685603L
#define PI_TARGET 3.141592653589793
#define MEASURE_REPEATS 5

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

double measure_time(long n) {
    struct timespec start, end;

    clock_gettime(CLOCK_MONOTONIC_RAW, &start);
    double pi = leibniz_calculation_of_pi(n);
    clock_gettime(CLOCK_MONOTONIC_RAW, &end);

    double result = end.tv_sec-start.tv_sec 
                    + 0.000000001*(end.tv_nsec-start.tv_nsec);


    printf("Pi = %.15f\n", pi);

    return result;
}

int main(void) {
    long n = DEFAULT_N;
    double best_time = 1000000.0;

    printf("N = %ld\n\n", n);

    for (int i = 0; i < MEASURE_REPEATS; i++) {
        double result = measure_time(n);
        printf("Run %d: %.6f s\n\n", i + 1, result);

        if (result < best_time) {
            best_time = result;
        }
    }

    printf("Best time: %.6f s\n", best_time);

    return 0;
}

//ниже main, который я использовала до замера времени, при проверке программы.

/*int main(int argc, char *argv[]) {
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
} */
