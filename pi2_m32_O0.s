leibniz_calculation_of_pi:
        pushl   %ebp
        movl    %esp, %ebp
        subl    $32, %esp
        fldz
        fstpl   -8(%ebp)
        fld1
        fstpl   -16(%ebp)
        movl    $0, -24(%ebp)
        movl    $0, -20(%ebp)
        jmp     .L2
.L3:
        fildq   -24(%ebp)
        fld     %st(0)
        faddp   %st, %st(1)
        fld1
        faddp   %st, %st(1)
        fstpl   -32(%ebp)
        fldl    -16(%ebp)
        fldl    .LC2
        fmulp   %st, %st(1)
        fdivl   -32(%ebp)
        fldl    -8(%ebp)
        faddp   %st, %st(1)
        fstpl   -8(%ebp)
        fldl    -16(%ebp)
        fchs
        fstpl   -16(%ebp)
        addl    $1, -24(%ebp)
        adcl    $0, -20(%ebp)
.L2:
        movl    8(%ebp), %eax
        cltd
        movl    -20(%ebp), %ecx
        cmpl    %eax, -24(%ebp)
        sbbl    %edx, %ecx
        jl      .L3
        fldl    -8(%ebp)
        leave
        ret
.LC4:
        .string "Error: N must be positive\n"
.LC6:
        .string "N = %lld\n"
.LC7:
        .string "Pi = %.15f\n"
.LC8:
        .string "Error = %.15f\n"
main:
        leal    4(%esp), %ecx
        andl    $-16, %esp
        pushl   -4(%ecx)
        pushl   %ebp
        movl    %esp, %ebp
        pushl   %ecx
        subl    $36, %esp
        movl    %ecx, %eax
        movl    $-1963183581, -16(%ebp)
        movl    $3, -12(%ebp)
        cmpl    $1, (%eax)
        jle     .L6
        movl    4(%eax), %eax
        addl    $4, %eax
        movl    (%eax), %eax
        subl    $12, %esp
        pushl   %eax
        call    atol
        addl    $16, %esp
        cltd
        movl    %eax, -16(%ebp)
        movl    %edx, -12(%ebp)
        movl    $0, %edx
        movl    $0, %eax
        cmpl    -16(%ebp), %edx
        sbbl    -12(%ebp), %eax
        jl      .L6
        movl    stderr, %eax
        pushl   %eax
        pushl   $26
        pushl   $1
        pushl   $.LC4
        call    fwrite
        addl    $16, %esp
        movl    $1, %eax
        jmp     .L7
.L6:
        movl    -16(%ebp), %eax
        subl    $12, %esp
        pushl   %eax
        call    leibniz_calculation_of_pi
        addl    $16, %esp
        fstpl   -24(%ebp)
        fldl    -24(%ebp)
        fldl    .LC5
        fsubrp  %st, %st(1)
        fabs
        fstpl   -32(%ebp)
        subl    $4, %esp
        pushl   -12(%ebp)
        pushl   -16(%ebp)
        pushl   $.LC6
        call    printf
        addl    $16, %esp
        subl    $4, %esp
        pushl   -20(%ebp)
        pushl   -24(%ebp)
        pushl   $.LC7
        call    printf
        addl    $16, %esp
        subl    $4, %esp
        pushl   -28(%ebp)
        pushl   -32(%ebp)
        pushl   $.LC8
        call    printf
        addl    $16, %esp
        movl    $0, %eax
.L7:
        movl    -4(%ebp), %ecx
        leave
        leal    -4(%ecx), %esp
        ret
.LC2:
        .long   0
        .long   1074790400
.LC5:
        .long   1413754136
        .long   1074340347

        
