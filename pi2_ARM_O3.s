leibniz_calculation_of_pi:
        cmp     r0, #0
        ble     .L4
        vmov.f64        d5, #1.0e+0
        movs    r3, #0
        vldr.64 d0, .L7
        vmov.f64        d2, #4.0e+0
        vmov.f64        d3, d5
.L3:
        vmov    s15, r3 @ int
        vmul.f64        d6, d5, d2
        adds    r3, r3, #1
        vneg.f64        d5, d5
        vcvt.f64.s32    d7, s15
        cmp     r0, r3
        vadd.f64        d7, d7, d7
        vadd.f64        d7, d7, d3
        vdiv.f64        d4, d6, d7
        vadd.f64        d0, d0, d4
        bne     .L3
        bx      lr
.L4:
        vldr.64 d0, .L7
        bx      lr
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
        push    {r3, lr}
        cmp     r0, #1
        vpush.64        {d8}
        bgt     .L17
        movw    r2, #12835
        movt    r2, 35580
        movs    r3, #3
        vldr.64 d8, .L19
.L10:
        movw    r0, #:lower16:.LC1
        movt    r0, #:upper16:.LC1
        bl      printf
        vmov    r2, r3, d8
        movw    r0, #:lower16:.LC2
        movt    r0, #:upper16:.LC2
        bl      printf
        vldr.64 d7, .L19+8
        movw    r0, #:lower16:.LC3
        movt    r0, #:upper16:.LC3
        vsub.f64        d8, d8, d7
        vabs.f64        d7, d8
        vmov    r2, r3, d7
        bl      printf
        movs    r0, #0
.L9:
        vldm    sp!, {d8}
        pop     {r3, pc}
.L17:
        ldr     r0, [r1, #4]
        movs    r2, #10
        movs    r1, #0
        bl      strtol
        asrs    r3, r0, #31
        cmp     r0, #1
        mov     r2, r0
        sbcs    r1, r3, #0
        blt     .L18
        vmov.f64        d5, #1.0e+0
        movs    r1, #0
        vldr.64 d8, .L19
        vmov.f64        d2, #4.0e+0
        vmov.f64        d3, d5
.L13:
        vmov    s15, r1 @ int
        vmul.f64        d6, d5, d2
        adds    r1, r1, #1
        vneg.f64        d5, d5
        vcvt.f64.s32    d7, s15
        cmp     r0, r1
        vadd.f64        d7, d7, d7
        vadd.f64        d7, d7, d3
        vdiv.f64        d4, d6, d7
        vadd.f64        d8, d8, d4
        bne     .L13
        b       .L10
.L18:
        movw    r3, #:lower16:stderr
        movt    r3, #:upper16:stderr
        movs    r2, #26
        movs    r1, #1
        movw    r0, #:lower16:.LC0
        movt    r0, #:upper16:.LC0
        ldr     r3, [r3]
        bl      fwrite
        movs    r0, #1
        b       .L9
.L19:
        .word   0
        .word   0
        .word   1413754136
        .word   1074340347


