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

    ; display characters
    cdecl	draw_char, 0, 0, 0x010F, 'A'
    cdecl	draw_char, 1, 0, 0x010F, 'B'
    cdecl	draw_char, 2, 0, 0x010F, 'C'

    cdecl	draw_char, 0, 0, 0x0402, '0'
    cdecl	draw_char, 1, 0, 0x0412, '1'
    cdecl	draw_char, 2, 0, 0x0412, '_'


    ; while(1)
    jmp     $


ALIGN 4, db 0
FONT_ADR:   dd  0

; --- modules ---
    %include    "../modules/protect/vga.s"
    %include    "../modules/protect/draw_char.s"

; --- padding ---
    times KERNEL_SIZE - ($ - $$) db 0x00
