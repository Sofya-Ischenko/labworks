leibniz_calculation_of_pi:
        push    {r4, r5, r7, lr}
        sub     sp, sp, #40
        add     r7, sp, #0
        strd    r0, [r7]
        mov     r2, #0
        mov     r3, #0
        strd    r2, [r7, #32]
        mov     r2, #0
        mov     r3, #0
        movt    r3, 16368
        strd    r2, [r7, #24]
        mov     r2, #0
        mov     r3, #0
        strd    r2, [r7, #16]
        b       .L2
.L3:
        ldrd    r0, [r7, #16]
        bl      __aeabi_l2d
        vmov    d7, r0, r1
        vadd.f64        d7, d7, d7
        vmov.f64        d6, #1.0e+0
        vadd.f64        d7, d7, d6
        vstr.64 d7, [r7, #8]
        vldr.64 d7, [r7, #24]
        vmov.f64        d6, #4.0e+0
        vmul.f64        d5, d7, d6
        vldr.64 d6, [r7, #8]
        vdiv.f64        d7, d5, d6
        vldr.64 d6, [r7, #32]
        vadd.f64        d7, d6, d7
        vstr.64 d7, [r7, #32]
        vldr.64 d7, [r7, #24]
        vneg.f64        d7, d7
        vstr.64 d7, [r7, #24]
        ldrd    r2, [r7, #16]
        adds    r4, r2, #1
        adc     r5, r3, #0
        strd    r4, [r7, #16]
.L2:
        ldrd    r0, [r7, #16]
        ldrd    r2, [r7]
        cmp     r0, r2
        sbcs    r3, r1, r3
        blt     .L3
        ldrd    r2, [r7, #32]
        vmov    d7, r2, r3
        vmov.f64        d0, d7
        adds    r7, r7, #40
        mov     sp, r7
        pop     {r4, r5, r7, pc}
.LC0:
        .ascii  "Error: N must be positive\012\000"
.LC1:
        .ascii  "N = %lld\012\000"
.LC2:
        .ascii  "Pi = %.15f\012\000"
.LC3:
        .ascii  "Error = %.15f\012\000"
main:
        push    {r4, r5, r7, lr}
        sub     sp, sp, #32
        add     r7, sp, #0
        str     r0, [r7, #4]
        str     r1, [r7]
        adr     r3, .L8+8
        ldrd    r2, [r3]
        strd    r2, [r7, #24]
        ldr     r3, [r7, #4]
        cmp     r3, #1
        ble     .L6
        ldr     r3, [r7]
        adds    r3, r3, #4
        ldr     r3, [r3]
        mov     r0, r3
        bl      atol
        mov     r3, r0
        asrs    r2, r3, #31
        mov     r4, r3
        mov     r5, r2
        strd    r4, [r7, #24]
        ldrd    r2, [r7, #24]
        cmp     r2, #1
        sbcs    r3, r3, #0
        bge     .L6
        movw    r3, #:lower16:stderr
        movt    r3, #:upper16:stderr
        ldr     r3, [r3]
        movs    r2, #26
        movs    r1, #1
        movw    r0, #:lower16:.LC0
        movt    r0, #:upper16:.LC0
        bl      fwrite
        movs    r3, #1
        b       .L7
.L6:
        ldrd    r0, [r7, #24]
        bl      leibniz_calculation_of_pi
        vstr.64 d0, [r7, #16]
        vldr.64 d7, [r7, #16]
        vldr.64 d6, .L8
        vsub.f64        d7, d7, d6
        vabs.f64        d7, d7
        vstr.64 d7, [r7, #8]
        ldrd    r2, [r7, #24]
        movw    r0, #:lower16:.LC1
        movt    r0, #:upper16:.LC1
        bl      printf
        ldrd    r2, [r7, #16]
        movw    r0, #:lower16:.LC2
        movt    r0, #:upper16:.LC2
        bl      printf
        ldrd    r2, [r7, #8]
        movw    r0, #:lower16:.LC3
        movt    r0, #:upper16:.LC3
        bl      printf
        movs    r3, #0
.L7:
        mov     r0, r3
        adds    r7, r7, #32
        mov     sp, r7
        pop     {r4, r5, r7, pc}
.L8:
        .word   1413754136
        .word   1074340347
        .word   -1963183581
        .word   3

        
