#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define N 2048
#define M 10

void mul(float *A, float *B, float *C, int n) {
    for (int i = 0; i < n * n; i++) {
        C[i] = 0.0f;
    }

    for (int i = 0; i < n; i++) {
        for (int k = 0; k < n; k++) {
            float a_ik = A[i * n + k];
            for (int j = 0; j < n; j++) {
                C[i * n + j] += a_ik * B[k * n + j];
            }
        }
    }
}

float check_inverse(float *A, float *A_inv, int n) {
    float *Check = malloc(n * n * sizeof(float));
    mul(A, A_inv, Check, n); 
    float max_error = 0.0f;

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            float ideal = (i == j) ? 1.0f : 0.0f;
            float err = fabsf(Check[i*n+j] - ideal);
            if (err > max_error) {
                max_error = err;
            }
        }
    }
    
    free(Check);
    return max_error;
}

int main() {
    int n = N, 
        m = M;

    size_t sz = (size_t)n * n * sizeof(float);

    float *A = malloc(sz), 
          *B = malloc(sz), 
          *R = malloc(sz),
          *P = malloc(sz), 
          *T = malloc(sz), 
          *S = malloc(sz);
    
    double min_time = 1000000000.0;
    for (int run = 0; run < 5; run++) {
        for (int i = 0; i < n * n; i++) {
            A[i] = 1.0f;
        }
        for (int i = 0; i < n; i++) {
            A[i * n + i] = (float)n + 2.0f; 
        }

        struct timespec start, end;
        clock_gettime(CLOCK_MONOTONIC_RAW, &start);

        float n1 = 0, 
              ni = 0;

        for (int i = 0; i < n; i++) {
            float cs = 0, 
                  rs = 0;
            for (int j = 0; j < n; j++) {
                cs += fabsf(A[j*n+i]);
                rs += fabsf(A[i*n+j]);
            }

            if (cs > n1) 
                n1 = cs;
            if (rs > ni) 
                ni = rs;
        }

        for (int i = 0; i < n; i++)
            for (int j = 0; j < n; j++)
                B[i*n+j] = A[j*n+i] / (n1 * ni);

        mul(B, A, T, n);
        for (int i = 0; i < n; i++)
            for (int j = 0; j < n; j++)
                R[i*n+j] = (i == j) - T[i*n+j];

        for (int i = 0; i < n*n; i++) 
            P[i] = S[i] = B[i];
        for (int it = 0; it < m - 1; it++) {
            mul(P, R, T, n);
            for (int i = 0; i < n*n; i++) {
                P[i] = T[i];
                S[i] += P[i];
            }
        }

        clock_gettime(CLOCK_MONOTONIC_RAW, &end);
        double program_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1000000000.0;
            
        if (program_time < min_time) {
            min_time = program_time;
        }
    }

    printf("Минимальное время (из 5 запусков): %.6f сек\n", min_time);
    
    float err = check_inverse(A, S, n);
    printf("Максимальная погрешность (M=%d): %e\n", m, err);

    free(A); 
    free(B); 
    free(R); 
    free(P); 
    free(T); 
    free(S);

    return 0;
}

