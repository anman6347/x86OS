    jmp     ipl


    ; BIOS Parameter Block
    times   90 - ($ - $$) db 0x90


    ; Initial Program Loader
ipl:
    BOOT_LOAD   equ     0x7c00

    cli

    mov     ax, 0x00
    mov     ds, ax
    mov     es, ax
    mov     ss, ax                  ; ds = es = ss = 0
    mov     sp, BOOT_LOAD           ; sp = 0x7c00

    sti

    mov     [BOOT.DRIVE],    dl     ; save drive number

    jmp     $                       ; while(1);


    ALIGN 2, db 0
BOOT:
.DRIVE:     dw  0                   ; Drive number


    times   510 - ($ - $$) db 0x00
    db      0x55, 0xAA              ; boot flag
