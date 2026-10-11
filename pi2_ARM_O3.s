leibniz_calculation_of_pi:
        push    {r3, r4, r5, r6, r7, lr}
        cmp     r0, #1
        sbcs    r3, r1, #0
        vpush.64        {d8, d9, d10, d11, d12}
        blt     .L4
        vmov.f64        d12, #1.0e+0
        movs    r4, #0
        mov     r6, r0
        mov     r7, r1
        vmov.f64        d8, d12
        mov     r5, r4
        vldr.64 d11, .L8
        vmov.f64        d9, #4.0e+0
.L3:
        mov     r0, r4
        mov     r1, r5
        bl      __aeabi_l2d
        vmov    d7, r0, r1
        vmul.f64        d10, d12, d9
        adds    r4, r4, #1
        vadd.f64        d7, d7, d7
        adc     r5, r5, #0
        vneg.f64        d12, d12
        cmp     r7, r5
        it      eq
        cmpeq   r6, r4
        vadd.f64        d7, d7, d8
        vdiv.f64        d6, d10, d7
        vadd.f64        d11, d11, d6
        bne     .L3
        vmov.f64        d0, d11
        vldm    sp!, {d8-d12}
        pop     {r3, r4, r5, r6, r7, pc}
.L4:
        vldr.64 d11, .L8
        vmov.f64        d0, d11
        vldm    sp!, {d8-d12}
        pop     {r3, r4, r5, r6, r7, pc}
.L8:
        .word   0
        .word   0
.LC0:
        .ascii  "Error: N must be positive\012\000"
.LC1:
        .ascii  "N = %lld\012\000"
.LC2:
        .ascii  "Pi = %.15f\012\000"
.LC3:
        .ascii  "Error = %.15f\012\000"
main:
        push    {r3, r4, r5, r6, r7, lr}
        cmp     r0, #1
        vpush.64        {d8, d9, d10, d11, d12}
        bgt     .L17
        movw    r6, #12835
        movt    r6, 35580
        movs    r7, #3
.L11:
        vmov.f64        d12, #1.0e+0
        movs    r4, #0
        vldr.64 d8, .L18
        mov     r5, r4
        vmov.f64        d9, d12
        vmov.f64        d10, #4.0e+0
.L13:
        mov     r0, r4
        mov     r1, r5
        bl      __aeabi_l2d
        vmov    d7, r0, r1
        vmul.f64        d11, d12, d10
        adds    r4, r4, #1
        vadd.f64        d7, d7, d7
        adc     r5, r5, #0
        vneg.f64        d12, d12
        cmp     r5, r7
        it      eq
        cmpeq   r4, r6
        vadd.f64        d7, d7, d9
        vdiv.f64        d6, d11, d7
        vadd.f64        d8, d8, d6
        bne     .L13
        mov     r2, r6
        mov     r3, r7
        movw    r0, #:lower16:.LC1
        movt    r0, #:upper16:.LC1
        bl      printf
        vmov    r2, r3, d8
        movw    r0, #:lower16:.LC2
        movt    r0, #:upper16:.LC2
        bl      printf
        vldr.64 d7, .L18+8
        movw    r0, #:lower16:.LC3
        movt    r0, #:upper16:.LC3
        vsub.f64        d8, d8, d7
        vabs.f64        d7, d8
        vmov    r2, r3, d7
        bl      printf
        movs    r0, #0
.L10:
        vldm    sp!, {d8-d12}
        pop     {r3, r4, r5, r6, r7, pc}
.L17:
        ldr     r0, [r1, #4]
        movs    r2, #10
        movs    r1, #0
        bl      strtol
        asrs    r7, r0, #31
        cmp     r0, #1
        mov     r6, r0
        sbcs    r3, r7, #0
        bge     .L11
        movw    r3, #:lower16:stderr
        movt    r3, #:upper16:stderr
        movs    r2, #26
        movs    r1, #1
        movw    r0, #:lower16:.LC0
        movt    r0, #:upper16:.LC0
        ldr     r3, [r3]
        bl      fwrite
        movs    r0, #1
        b       .L10
.L18:
        .word   0
        .word   0
        .word   1413754136
        .word   1074340347

        
