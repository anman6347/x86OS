; void get_font_adr(long adr);
; adr = addr to BIOS font data

get_font_data:

    ; build stack frame
    push    bp
    mov     bp, sp

    ; save registers
    push    ax
    push    bx
    push    si
    push    es
    push    bp

    ; get the arg
    mov     si, [bp + 4]
    
    ; get BIOS font addr
    mov     ax, 0x1130      ; get current character generator information
    mov     bh, 0x06        ; 8x16 character
    int     10h             ; ES:BP = font addr

    ; save font address
    mov     [si + 0], es    ; segment
    mov     [si + 2], bp    ; offset

    ; return registers
    pop     bp
    pop     es
    pop     si
    pop     bx
    pop     ax

    ; destroy stack frame
    mov     sp, bp
    pop     bp

    ret
