leibniz_calculation_of_pi:
        pushq   %rbp
        movq    %rsp, %rbp
        movq    %rdi, -40(%rbp)
        pxor    %xmm0, %xmm0
        movsd   %xmm0, -8(%rbp)
        movsd   .LC1(%rip), %xmm0
        movsd   %xmm0, -16(%rbp)
        movq    $0, -24(%rbp)
        jmp     .L2
.L3:
        pxor    %xmm0, %xmm0
        cvtsi2sdq       -24(%rbp), %xmm0
        movapd  %xmm0, %xmm1
        addsd   %xmm0, %xmm1
        movsd   .LC1(%rip), %xmm0
        addsd   %xmm1, %xmm0
        movsd   %xmm0, -32(%rbp)
        movsd   -16(%rbp), %xmm1
        movsd   .LC2(%rip), %xmm0
        mulsd   %xmm1, %xmm0
        divsd   -32(%rbp), %xmm0
        movsd   -8(%rbp), %xmm1
        addsd   %xmm1, %xmm0
        movsd   %xmm0, -8(%rbp)
        movsd   -16(%rbp), %xmm0
        movq    .LC3(%rip), %xmm1
        xorpd   %xmm1, %xmm0
        movsd   %xmm0, -16(%rbp)
        addq    $1, -24(%rbp)
.L2:
        movq    -24(%rbp), %rax
        cmpq    -40(%rbp), %rax
        jl      .L3
        movsd   -8(%rbp), %xmm0
        popq    %rbp
        ret
.LC4:
        .string "Error: N must be positive\n"
.LC7:
        .string "N = %lld\n"
.LC8:
        .string "Pi = %.15f\n"
.LC9:
        .string "Error = %.15f\n"
main:
        pushq   %rbp
        movq    %rsp, %rbp
        subq    $48, %rsp
        movl    %edi, -36(%rbp)
        movq    %rsi, -48(%rbp)
        movabsq $15216685603, %rax
        movq    %rax, -8(%rbp)
        cmpl    $1, -36(%rbp)
        jle     .L6
        movq    -48(%rbp), %rax
        addq    $8, %rax
        movq    (%rax), %rax
        movq    %rax, %rdi
        call    atol
        movq    %rax, -8(%rbp)
        cmpq    $0, -8(%rbp)
        jg      .L6
        movq    stderr(%rip), %rax
        movq    %rax, %rcx
        movl    $26, %edx
        movl    $1, %esi
        movl    $.LC4, %edi
        call    fwrite
        movl    $1, %eax
        jmp     .L7
.L6:
        movq    -8(%rbp), %rax
        movq    %rax, %rdi
        call    leibniz_calculation_of_pi
        movq    %xmm0, %rax
        movq    %rax, -16(%rbp)
        movsd   -16(%rbp), %xmm0
        movsd   .LC5(%rip), %xmm1
        subsd   %xmm1, %xmm0
        movq    .LC6(%rip), %xmm1
        andpd   %xmm1, %xmm0
        movsd   %xmm0, -24(%rbp)
        movq    -8(%rbp), %rax
        movq    %rax, %rsi
        movl    $.LC7, %edi
        movl    $0, %eax
        call    printf
        movq    -16(%rbp), %rax
        movq    %rax, %xmm0
        movl    $.LC8, %edi
        movl    $1, %eax
        call    printf
        movq    -24(%rbp), %rax
        movq    %rax, %xmm0
        movl    $.LC9, %edi
        movl    $1, %eax
        call    printf
        movl    $0, %eax
.L7:
        leave
        ret
.LC1:
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
.LC5:
        .long   1413754136
        .long   1074340347
.LC6:
        .long   -1
        .long   2147483647
        .long   0
        .long   0

        
