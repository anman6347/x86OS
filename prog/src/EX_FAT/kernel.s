    ; --- macro ---
    %include    "../include/define.s"
    %include    "../include/macro.s"

    ORG     KERNEL_LOAD

[BITS 32]

    ; --- entry point ---
kernel:
    ; get 8 * 16 BIOS font address (exsisted at the end of MBR)
    mov     esi, BOOT_LOAD + SECT_SIZE      ; ESI = 0x7c00 + 512
    movzx   eax, word [esi + 0]             ; segment for font addr (ESI + 0 not equals DS:ESI)
    movzx   ebx, word [esi + 2]             ; offset for font addr
    shl     eax , 4
    add     eax, ebx                        ; seg:off in real mode
    mov     [FONT_ADR], eax

    ; display all characters obtained by int 0x10 order
    ;cdecl	draw_font, 63, 13

    ; Hello Kernel!
    cdecl	draw_str, 15, 0, 0x0004, .s0
    cdecl	draw_str, 15, 1, 0x0004, .s1
    cdecl	draw_str, 15, 2, 0x0004, .s2
    cdecl	draw_str, 15, 3, 0x0004, .s3
    cdecl	draw_str, 15, 4, 0x0004, .s4
    cdecl	draw_str, 15, 5, 0x0004, .s5
    cdecl	draw_str, 15, 6, 0x0004, .s6
    cdecl	draw_str, 15, 7, 0x0004, .s7
    cdecl	draw_str, 15, 8, 0x0004, .s8
    cdecl	draw_str, 15, 9, 0x0004, .s9
    cdecl	draw_str, 15, 10, 0x0004, .s10
    cdecl	draw_str, 15, 11, 0x0004, .s11
    cdecl	draw_str, 15, 12, 0x0004, .s12
    cdecl	draw_str, 15, 13, 0x0004, .s13
    cdecl	draw_str, 15, 14, 0x0004, .s14
    cdecl	draw_str, 15, 15, 0x0004, .s15
    cdecl	draw_str, 15, 16, 0x0004, .s16
    cdecl	draw_str, 15, 17, 0x0004, .s17
    cdecl	draw_str, 15, 18, 0x0004, .s18
    cdecl	draw_str, 15, 19, 0x0004, .s19
    cdecl	draw_str, 15, 20, 0x0004, .s20
    cdecl	draw_str, 15, 21, 0x0004, .s21
    cdecl	draw_str, 15, 22, 0x0004, .s22
    cdecl	draw_str, 15, 23, 0x0004, .s23
    cdecl	draw_str, 15, 24, 0x0004, .s24
    cdecl	draw_str, 15, 25, 0x0004, .s25
    cdecl	draw_str, 15, 26, 0x0004, .s26
    cdecl	draw_str, 15, 27, 0x0004, .s27
    cdecl	draw_str, 15, 28, 0x0004, .s28
    cdecl	draw_str, 15, 29, 0x0004, .s29





    ; while(1)
    jmp     $

.s0:    db  "               \\\\\\\\\\\\\\\", 0x00
.s1:    db  "               \\\\\\\\\\\\\\\", 0x00
.s2:    db  "            \\\\\\\\\\\\\\\\\\\\\\\\\\\", 0x00
.s3:    db  "            \\\\\\\\\\\\\\\\\\\\\\\\\\\", 0x00
.s4:    db  "            #########++++++###+++", 0x00
.s5:    db  "            #########++++++###+++", 0x00
.s6:    db  "         ###+++###+++++++++###++++++", 0x00
.s7:    db  "         ###+++###+++++++++###++++++", 0x00
.s8:    db  "         ###+++######+++++++++###+++++++++", 0x00
.s9:    db  "         ###+++######+++++++++###+++++++++", 0x00
.s10:    db  "         ######++++++++++++###############", 0x00
.s11:    db  "         ######++++++++++++###############", 0x00
.s12:    db  "               +++++++++++++++++++++", 0x00
.s13:    db  "               +++++++++++++++++++++", 0x00
.s14:    db  "            ######\\\#########", 0x00
.s15:    db  "            ######\\\#########", 0x00
.s16:    db  "         #########\\\######\\\#########", 0x00
.s17:    db  "         #########\\\######\\\#########", 0x00
.s18:    db  "      ############\\\\\\\\\\\\############", 0x00
.s19:    db  "      ############\\\\\\\\\\\\############", 0x00
.s20:    db  "      ++++++###\\\+++\\\\\\+++\\\###++++++", 0x00
.s21:    db  "      ++++++###\\\+++\\\\\\+++\\\###++++++", 0x00
.s22:    db  "      +++++++++\\\\\\\\\\\\\\\\\\+++++++++", 0x00
.s23:    db  "      +++++++++\\\\\\\\\\\\\\\\\\+++++++++", 0x00
.s24:    db  "      ++++++\\\\\\\\\\\\\\\\\\\\\\\\++++++", 0x00
.s25:    db  "      ++++++\\\\\\\\\\\\\\\\\\\\\\\\++++++", 0x00
.s26:    db  "            \\\\\\\\\      \\\\\\\\\", 0x00
.s27:    db  "            \\\\\\\\\      \\\\\\\\\", 0x00
.s28:    db  "         #########            #########", 0x00
.s29:    db  "         #########            #########", 0x00


ALIGN 4, db 0
FONT_ADR:   dd  0

; --- modules ---
    %include    "../modules/protect/vga.s"
    %include    "../modules/protect/draw_char.s"
    %include    "../modules/protect/draw_font.s"
    %include	"../modules/protect/draw_str.s"

; --- padding ---
    times KERNEL_SIZE - ($ - $$) db 0x00

; --- FAT ---
    %include	"fat.s"
