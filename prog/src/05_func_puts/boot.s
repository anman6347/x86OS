    BOOT_LOAD   equ     0x7c00
    ORG     BOOT_LOAD

    ; --- macro ---
    %include    "../include/macro.s"


    ; --- entry point ---
entry: 
    jmp     ipl


    ; --- BIOS Parameter Block ---
    times   90 - ($ - $$) db 0x90


    ; --- Initial Program Loader ---
ipl:

    cli

    mov     ax, 0x00
    mov     ds, ax
    mov     es, ax
    mov     ss, ax                  ; ds = es = ss = 0
    mov     sp, BOOT_LOAD           ; sp = 0x7c00

    sti

    mov     [BOOT.DRIVE],    dl     ; save drive number

    cdecl   puts, .s0               ; write text in teletype mode


    jmp     $                       ; while(1);

.s0:    db  "Booting...", 0x0A, 0x0D, 0x00

    ALIGN 2, db 0
BOOT:
.DRIVE:     dw  0                   ; Drive number

    ; --- modules ---
    %include    "../modules/real/putc.s"
    %include    "../modules/real/puts.s"

    ; --- boot flag ---
    times   510 - ($ - $$) db 0x00
    db      0x55, 0xAA              ; boot flag
