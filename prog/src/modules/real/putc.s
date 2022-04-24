; void putc(int16 chcode)

putc:

    ; build stack frame
    push    bp
    mov     bp, sp

    ; save registers
    push    ax
    push    bx


    ; write text in teletype mode
    mov     al, [bp + 4]
    mov     ah, 0x0E
    mov     bx, 0x00
    int     0x10


    ; return registers
    pop     bx
    pop     ax

    ; destroy stack frame
    mov     sp, bp
    pop     bp

    ret
