; int get_drive_param(int drive)

; set maximam accessible number of sectors, cylinders and heads coressponding drive number

; drive: addr to drive struct
; return non-zero on success, and 0 on error 


read_chs:

    ; build stack frame
    push    bp
    mov     bp, sp

    ; save registers
    push    bx
    push    cx
    push    es
    push    si
    push    di

    
    mov     si, [bp + 4]                ; si = addr to drive struct

    ; initialize Disk Base Table pointer
    mov     ax, 0
    mov     es, ax
    mov     di, ax

    ; get current drive parameters
    mov     ah, 8
    mov     dl, [si + drive.no]
    int     0x13
    jc      .10F
    ; success
    mov     al, cl
    and     al, 0x3F        ; ax = number of sectors

    shr     cl, 6
    ror     cx, 8
    inc     cx              ; cx = number of cylinders

    movzx   bx, dh
    inc     bx              ; bx = number of heads

    mov     [si + drive.sect], ax
    mov     [si + drive.cyln], cx
    mov     [si + drive.head], bx

    jmp     .10E
    ; error
.10F:
    mov     ax, 0


.10E:
    ; return registers
    pop     di
    pop     si
    pop     es
    pop     cx
    pop     bx

    ; destroy stack frame
    mov     sp, bp
    pop     bp

    ret
