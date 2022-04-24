; void puts(int16 straddr)
; write str from head to '\0'


puts:

    ; build stack frame
    push    bp
    mov     bp, sp

    ; save registers
    push    ax
    push    bx
    push    si

    ; get arg
    mov     si, [bp + 4]    ; si = straddr

    ; write text in teletype mode
    mov     ah, 0x0E
    mov     bx, 0x00
    cld                     ; DF = 0    
.10L:
    lodsb
    cmp     al, 0           ; if (*(si++) == 0)
    je      .10E            ; break;
    int     0x10
    jmp     .10L
.10E:

    ; return registers
    pop     si
    pop     bx
    pop     ax

    ; destroy stack frame
    mov     sp, bp
    pop     bp

    ret
