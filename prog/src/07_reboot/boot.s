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

    cdecl   itoa, -1, .s1, 9, 16, 0b0100
    cdecl   puts, .s1

    cdecl   reboot

    jmp     $                       ; while(1);

.s0:    db  "Booting...", 0x0A, 0x0D, 0x00

.s1:    db  "---------", 0x0A, 0x0D, 0x00

    ALIGN 2, db 0
BOOT:
.DRIVE:     dw  0                   ; Drive number

    ; --- modules ---
    %include    "../modules/real/putc.s"
    %include    "../modules/real/puts.s"
    %include    "../modules/real/itoa.s"
    %include    "../modules/real/reboot.s"

    ; --- boot flag ---
    times   510 - ($ - $$) db 0x00
    db      0x55, 0xAA              ; boot flag
