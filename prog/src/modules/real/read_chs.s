; int read_chs(int drive, int sect, int dst)
; return number of sectors read
; drive: addr to drive struct
; sect: number of read sectors
; dst: dst addr

; can't call this func before DS = 0, maybe


read_chs:

    ; build stack frame
    push    bp
    mov     bp, sp
    push    3           ; number of retries
    push    0           ; number of sectors read

    ; save registers
    push    bx
    push    cx
    push    dx
    push    es
    push    si

    ; set cx, dx, es, bx for reading sectors (CHS)
    mov     si, [bp + 4]                ; si = addr to drive struct
    mov     ch, [si + drive.cyln] 
    mov     cl, [si + drive.cyln + 1]
    shl     cl, 6
    or      cl, [si + drive.sect]

    mov     dh, [si + drive.head]
    mov     dl, [si + 0]

    mov     ax, 0
    mov     es, ax
    mov     bx, [bp + 8]

.10L:
    ; read sectors
    mov     ah, 0x02
    mov     al, [bp + 6]

    int     0x13
    jnc      .11E        ; if error occured, jump to .11E
    mov     al, 0
    jmp     .10E

.11E:
    cmp     al, 0
    jne     .10E        ; if at least one sector was read

    mov     ax, 0
    dec     word    [bp - 2]    ; retry--
    jnz     .10L                ; read sectors again

.10E:
    ; remove status info
    mov     ah, 0

    ; return registers
    pop     si
    pop     es
    pop     dx
    pop     cx
    pop     bx

    ; destroy stack frame
    mov     sp, bp
    pop     bp

    ret
