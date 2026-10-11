leibniz_calculation_of_pi:
        push    {r3, r4, r5, r6, r7, lr}
        vpush.64        {d8, d9, d10, d11, d12}
        cmp     r0, #0
        ble     .L4
        mov     r6, r0
        asrs    r7, r0, #31
        movs    r4, #0
        mov     r5, r4
        vmov.f64        d8, #1.0e+0
        vldr.64 d9, .L7
        vmov.f64        d12, #4.0e+0
        vmov.f64        d11, d8
.L3:
        vmul.f64        d10, d8, d12
        mov     r0, r4
        mov     r1, r5
        bl      __aeabi_l2d
        vmov    d7, r0, r1
        vadd.f64        d7, d7, d7
        vadd.f64        d7, d7, d11
        vdiv.f64        d6, d10, d7
        vadd.f64        d9, d9, d6
        vneg.f64        d8, d8
        adds    r2, r4, #1
        adc     r3, r5, #0
        mov     r4, r2
        mov     r5, r3
        cmp     r3, r7
        it      eq
        cmpeq   r2, r6
        bne     .L3
.L1:
        vmov.f64        d0, d9
        vldm    sp!, {d8-d12}
        pop     {r3, r4, r5, r6, r7, pc}
.L4:
        vldr.64 d9, .L7
        b       .L1
.L7:
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
        push    {r3, r4, r5, lr}
        vpush.64        {d8}
        cmp     r0, #1
        ble     .L12
        mov     r3, r1
        movs    r2, #10
        movs    r1, #0
        ldr     r0, [r3, #4]
        bl      strtol
        asrs    r3, r0, #31
        mov     r4, r0
        mov     r5, r3
        cmp     r0, #1
        sbcs    r3, r3, #0
        blt     .L14
.L10:
        mov     r0, r4
        bl      leibniz_calculation_of_pi
        vmov.f64        d8, d0
        mov     r2, r4
        mov     r3, r5
        movw    r0, #:lower16:.LC1
        movt    r0, #:upper16:.LC1
        bl      printf
        vmov    r2, r3, d8
        movw    r0, #:lower16:.LC2
        movt    r0, #:upper16:.LC2
        bl      printf
        vldr.64 d7, .L15
        vsub.f64        d8, d8, d7
        vabs.f64        d7, d8
        vmov    r2, r3, d7
        movw    r0, #:lower16:.LC3
        movt    r0, #:upper16:.LC3
        bl      printf
        movs    r0, #0
.L9:
        vldm    sp!, {d8}
        pop     {r3, r4, r5, pc}
.L14:
        movw    r3, #:lower16:stderr
        movt    r3, #:upper16:stderr
        ldr     r3, [r3]
        movs    r2, #26
        movs    r1, #1
        movw    r0, #:lower16:.LC0
        movt    r0, #:upper16:.LC0
        bl      fwrite
        movs    r0, #1
        b       .L9
.L12:
        movw    r4, #12835
        movt    r4, 35580
        movs    r5, #3
        b       .L10
.L15:
        .word   1413754136
        .word   1074340347


        
