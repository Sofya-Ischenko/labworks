leibniz_calculation_of_pi:
        testq   %rdi, %rdi
        jle     .L4
        movsd   .LC0(%rip), %xmm4
        movsd   .LC2(%rip), %xmm5
        xorl    %eax, %eax
        pxor    %xmm3, %xmm3
        movapd  %xmm4, %xmm2
.L3:
        pxor    %xmm0, %xmm0
        movapd  %xmm2, %xmm1
        xorpd   .LC3(%rip), %xmm2
        cvtsi2sdq       %rax, %xmm0
        addsd   %xmm0, %xmm0
        mulsd   %xmm5, %xmm1
        addq    $1, %rax
        addsd   %xmm4, %xmm0
        divsd   %xmm0, %xmm1
        addsd   %xmm1, %xmm3
        cmpq    %rax, %rdi
        jne     .L3
        movapd  %xmm3, %xmm0
        ret
.L4:
        pxor    %xmm3, %xmm3
        movapd  %xmm3, %xmm0
        ret
.LC4:
        .string "Error: N must be positive\n"
.LC5:
        .string "N = %ld\n"
.LC6:
        .string "Pi = %.15f\n"
.LC9:
        .string "Error = %.15f\n"
main:
        subq    $24, %rsp
        cmpl    $1, %edi
        jg      .L15
        movabsq $15216685603, %rsi
.L8:
        movsd   .LC0(%rip), %xmm4
        movsd   .LC2(%rip), %xmm5
        pxor    %xmm0, %xmm0
        xorl    %edx, %edx
        movapd  %xmm4, %xmm3
.L10:
        pxor    %xmm1, %xmm1
        movapd  %xmm3, %xmm2
        xorpd   .LC3(%rip), %xmm3
        cvtsi2sdq       %rdx, %xmm1
        addsd   %xmm1, %xmm1
        mulsd   %xmm5, %xmm2
        addq    $1, %rdx
        addsd   %xmm4, %xmm1
        divsd   %xmm1, %xmm2
        addsd   %xmm2, %xmm0
        cmpq    %rdx, %rsi
        jne     .L10
        movl    $.LC5, %edi
        xorl    %eax, %eax
        movsd   %xmm0, 8(%rsp)
        call    printf
        movsd   8(%rsp), %xmm0
        movl    $.LC6, %edi
        movl    $1, %eax
        call    printf
        movsd   8(%rsp), %xmm0
        movl    $.LC9, %edi
        subsd   .LC7(%rip), %xmm0
        andpd   .LC8(%rip), %xmm0
        movl    $1, %eax
        call    printf
        xorl    %eax, %eax
.L7:
        addq    $24, %rsp
        ret
.L15:
        movq    8(%rsi), %rdi
        movl    $10, %edx
        xorl    %esi, %esi
        call    __isoc23_strtol
        movq    %rax, %rsi
        testq   %rax, %rax
        jg      .L8
        movl    $26, %edx
        movl    $1, %esi
        movl    $.LC4, %edi
        movq    stderr(%rip), %rcx
        call    fwrite
        movl    $1, %eax
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

        
