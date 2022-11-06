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
    cdecl	draw_font, 63, 13

    ; Hello Kernel!
    cdecl	draw_str, 25, 14, 0x040F, s0

    ; while(1)
    jmp     $

.dbg:   db 65

ALIGN 4, db 0
FONT_ADR:   dd  0
s0:    db  "Hello, kernel!", 0x00
; --- modules ---
    %include    "../modules/protect/vga.s"
    %include    "../modules/protect/draw_char.s"
    %include    "../modules/protect/draw_font.s"
    %include	"../modules/protect/draw_str.s"

; --- padding ---
    times KERNEL_SIZE - ($ - $$) db 0x00
