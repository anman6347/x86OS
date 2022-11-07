; void lba_chs(struct drive *drive, struct drive *drv_chs, int16 lba);

; return non-zero on success, and 0 on error
; drive : addr to drive params
; drv_chs : addr to CHS (struct drive) converted from LBA
; lba : this will be converted to CHS


lba_chs:

    ; build stack frame
    push    bp
    mov     bp, sp

    ; save registers
    push    ax
    push    bx
    push    dx
    push    si
    push    di


    ; convert LBA to CHS
    mov     si, [bp + 4]        ; SI = *drive;
    mov     di, [bp + 6]        ; DI = *drive_chs;

    ; calculate num of sectors per cylinder
    mov     al, [si + drive.head]
    mul     byte [si + drive.sect]  ; AX = num of heads * num of sects per track
    mov     bx, ax

    ; calculate C
    mov     dx, 0
    mov     ax, [bp + 8]
    div     bx                      ; AX = DX:AX / BX, DX = DX:AX % BX;
    mov     [di + drive.cyln], ax

    ; calculate H and S
    mov     ax, dx
    div     byte [si + drive.sect]  ; AH = AX % num of sects per track;
                                    ; AL = AX / num of sects per track;
    movzx   dx, ah                  ; DX = S
    mov     ah, 0x00                ; AX = C
    inc     dx

    mov     [di + drive.head], ax
    mov     [di + drive.sect], dx


    ; return registers
    pop     di
    pop     si
    pop     dx
    pop     bx
    pop     ax

    ; destroy stack frame
    mov     sp, bp
    pop     bp

    ret
