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
    %include    "../modules/real/puts.s"
    %include    "../modules/real/reboot.s"
    %include    "../modules/real/read_chs.s"


    ; --- boot flag ---
    times   510 - ($ - $$) db 0x00
    db      0x55, 0xAA              ; boot flag


    ; ----------------------------
    ; informations obtained in real mode
    ; ----------------------------

    ; BIOS font data addr
FONT:
.seg    dw  0
.off    dw  0
    ; ACPI data address 
ACPI_DATA:
.adr:   dd  0
.len:   dd  0

    ; ----------------------------
    ; --- 2nd stage of booting ---
    ; ----------------------------

    ; --- modules ---
    %include    "../modules/real/putc.s"
    %include    "../modules/real/itoa.s"
    %include    "../modules/real/get_drive_params.s"
    %include    "../modules/real/get_font_adr.s"

stage_2:
    cdecl   puts, .s0               ; display a message

    ; get drive params
    cdecl   get_drive_params, BOOT
    cmp     ax, 0
    jne     .10E
    cdecl   puts, .e0               ; display an error message
    call    reboot
.10E:
    ; display information of drive params
    mov     ax, [BOOT + drive.no]
    cdecl   itoa, ax, .p1, 2, 16, 0b0100
    mov     ax, [BOOT + drive.cyln]
    cdecl   itoa, ax, .p2, 4, 16, 0b0100
    mov     ax, [BOOT + drive.head]
    cdecl   itoa, ax, .p3, 2, 16, 0b0100
    mov     ax, [BOOT + drive.sect]
    cdecl   itoa, ax, .p4, 2, 16, 0b0100
    cdecl   puts, .s1                       ; puts(.s1 ~ .p4)

    ; transition to the 3rd stage
    jmp     stage_3rd

.s0:    db  "2nd stage...", 0x0A, 0x0D, 0

.s1:    db  " Drive:0x"
.p1:    db  "  , C:0x"
.p2:    db  "    , H:0x"
.p3:    db  "  , S:0x"
.p4:    db  "  ", 0x0A, 0x0D, 0

.e0:    db  "Can't get drive parameter.", 0


    ; ----------------------------
    ; --- 3rd stage of booting ---
    ; ----------------------------

    ; --- modules ---
    %include    "../modules/real/get_mem_info.s"

stage_3rd:
    cdecl   puts, .s0               ; display a message

    ; get BIOS font data
    cdecl   get_font_data, FONT

    ; display font addr
    cdecl   itoa, word[FONT.seg], .p1, 4, 16, 0b0100
    cdecl   itoa, word[FONT.off], .p2, 4, 16, 0b0100
    cdecl   puts, .s1

    ; display mem info
    cdecl   get_mem_info

    mov     eax, [ACPI_DATA.adr]    ; 32bit
    cmp     eax, 0
    je      .10E
    cdecl   itoa, ax, .p4, 4, 16, 0b0100
    shr     eax, 16
    cdecl   itoa, ax, .p3, 4, 16, 0b0100

    cdecl   puts, .s2

.10E:
    jmp     $                       ; while(1);


.s0:    db  "3rd stage...", 0x0A, 0x0D, 0
.s1:    db  " Font Address="
.p1:    db  "ZZZZ:"
.p2:    db  "ZZZZ", 0x0A, 0x0D
        db  0x0A, 0x0D, 0

.s2:    db  " ACPI data="
.p3:    db  "ZZZZ"
.p4:    db  "ZZZZ", 0x0A, 0x0D, 0
    ; --- padding ---
    times BOOT_SIZE - ($- $$)  db  0   ; up to 8K
