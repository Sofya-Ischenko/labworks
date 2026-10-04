leibniz_calculation_of_pi:
        testq   %rdi, %rdi
        jle     .L4
        movl    $0, %eax
        movsd   .LC0(%rip), %xmm2
        pxor    %xmm3, %xmm3
        movsd   .LC2(%rip), %xmm6
        movapd  %xmm2, %xmm5
        movq    .LC3(%rip), %xmm4
.L3:
        movapd  %xmm2, %xmm1
        mulsd   %xmm6, %xmm1
        pxor    %xmm0, %xmm0
        cvtsi2sdq       %rax, %xmm0
        addsd   %xmm0, %xmm0
        addsd   %xmm5, %xmm0
        divsd   %xmm0, %xmm1
        addsd   %xmm1, %xmm3
        xorpd   %xmm4, %xmm2
        addq    $1, %rax
        cmpq    %rax, %rdi
        jne     .L3
.L1:
        movapd  %xmm3, %xmm0
        ret
.L4:
        pxor    %xmm3, %xmm3
        jmp     .L1
.LC4:
        .string "Error: N must be positive\n"
.LC5:
        .string "N = %ld\n"
.LC6:
        .string "Pi = %.15f\n"
.LC9:
        .string "Error = %.15f\n"
main:
        pushq   %rbx
        subq    $16, %rsp
        cmpl    $1, %edi
        jle     .L9
        movq    8(%rsi), %rdi
        movl    $10, %edx
        movl    $0, %esi
        call    __isoc23_strtol
        movq    %rax, %rbx
        testq   %rax, %rax
        jle     .L11
.L7:
        movq    %rbx, %rdi
        call    leibniz_calculation_of_pi
        movsd   %xmm0, 8(%rsp)
        movq    %rbx, %rsi
        movl    $.LC5, %edi
        movl    $0, %eax
        call    printf
        movsd   8(%rsp), %xmm0
        movl    $.LC6, %edi
        movl    $1, %eax
        call    printf
        movsd   8(%rsp), %xmm0
        subsd   .LC7(%rip), %xmm0
        andpd   .LC8(%rip), %xmm0
        movl    $.LC9, %edi
        movl    $1, %eax
        call    printf
        movl    $0, %eax
.L6:
        addq    $16, %rsp
        popq    %rbx
        ret
.L11:
        movq    stderr(%rip), %rcx
        movl    $26, %edx
        movl    $1, %esi
        movl    $.LC4, %edi
        call    fwrite
        movl    $1, %eax
        jmp     .L6
.L9:
        movabsq $15216685603, %rbx
        jmp     .L7
.LC0:
        .long   0
        .long   1072693248
.LC2:
        .long   0
        .long   1074790400
.LC3:
        .long   0
        .long   -2147483648
        .long   0
        .long   0
.LC7:
        .long   1413754136
        .long   1074340347
.LC8:
        .long   -1
        .long   2147483647
        .long   0
        .long   0

