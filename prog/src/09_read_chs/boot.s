    ; --- macro ---
    %include    "../include/define.s"
    %include    "../include/macro.s"

    ORG     BOOT_LOAD

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
    mov     ss, ax                      ; ds = es = ss = 0
    mov     sp, BOOT_LOAD               ; sp = 0x7c00

    sti

    mov     [BOOT + drive.no],    dl    ; save drive number

    cdecl   puts, .s0                   ; write text in teletype mode


    ; read all the sectors left
    mov     bx, BOOT_SECT - 1               ; bx = number of sectors left
    mov     cx, BOOT_LOAD + SECT_SIZE       ; cx = addr where next sectors will be loaded
    cdecl   read_chs, BOOT, bx, cx          ; ax = read_chs(BOOT, bx, cx);

    cmp     ax, bx
    jz      .10E                    ; if success, jump to .10E

    cdecl   puts, .e0
    call    reboot
.10E:

    ; transition to the 2nd stage
    jmp     stage_2



.s0:    db  "Booting...", 0x0A, 0x0D, 0x00
.e0:    db  "Error:sector read", 0x00

    ALIGN 2, db 0
BOOT:
    istruc  drive
        at  drive.no,   dw  0   ; drive number
        at  drive.cyln, dw  0   ; cylinder
        at  drive.head, dw  0   ; head
        at  drive.sect, dw  2   ; sector
    iend

    ; --- modules ---
;    %include    "../modules/real/putc.s"
    %include    "../modules/real/puts.s"
;    %include    "../modules/real/itoa.s"
    %include    "../modules/real/reboot.s"
    %include    "../modules/real/read_chs.s"

    ; --- boot flag ---
    times   510 - ($ - $$) db 0x00
    db      0x55, 0xAA              ; boot flag



    ; ----------------------------
    ; --- 2nd stage of booting ---
    ; ----------------------------
stage_2:
    cdecl   puts, .s0

    jmp     $                       ; while(1);

.s0:    db  "2nd stage...", 0x0A, 0x0D, 0

    ; --- padding ---
    times BOOT_SIZE - ($- $$)  db  0   ; up to 8K
