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

    ; display 8dot hlines
    mov     ah, 0x07                        ; i = 0, r = 1, g = 1, b = 1
    mov     al, 0x02                        ; index
    mov     dx, 0x03C4
    out     dx, ax
    mov     [0x000A_0000 + 0], byte 0xFF    ; 8dot hline

    mov     ah, 0x04                        ; i = 0, r = 1, g = 0, b = 0
    out     dx, ax
    mov     [0x000A_0000 + 1], byte 0xFF    ; 8dot hline

    mov     ah, 0x02                        ; i = 0, r = 0, g = 1, b = 0
    out     dx, ax
    mov     [0x000A_0000 + 2], byte 0xFF    ; 8dot hline

    mov     ah, 0x01                        ; i = 0, r = 0, g = 0, b = 1
    out     dx, ax
    mov     [0x000A_0000 + 3], byte 0xFF    ; 8dot hline

    ; display 640dot(= screen width) hline
    mov     ah, 0x0B                        ; i = 1, r = 0, g = 1, b = 1
    out     dx, ax

    lea     edi, [0x000A_0000 + 80]         ; EDI = 0xA0000 + 80
    mov     ecx, 80                         ; counter
    mov     al, 0xFF
    cld                                     ; positive direction
    rep     stosb                           ; *EDI++ = AL

    ; display 8dot square on the 2nd line
    mov     edi, 1
    ; 80 * 16 = 1280 = 256 * 5 (to accelerate calculation)
    shl     edi, 8
    lea     edi, [0xA_0000 + edi * 5]

    mov     [edi + (80 * 0)], word  0xFF    
    mov     [edi + (80 * 1)], word  0xFF
    mov     [edi + (80 * 2)], word  0xFF
    mov     [edi + (80 * 3)], word  0xFF
    mov     [edi + (80 * 4)], word  0xFF
    mov     [edi + (80 * 5)], word  0xFF
    mov     [edi + (80 * 6)], word  0xFF
    mov     [edi + (80 * 7)], word  0xFF

    ; display character 'A'
    mov     esi, 'A'
    shl     esi, 4                          ; the size of a character is 16byte
    add     esi, [FONT_ADR]                 ; *ESI = the font of 'A'
    ; 80 * 2 * 16 = 512 * 5
    mov     edi, 2
    shl     edi, 8
    lea     edi, [0xA_0000 + edi * 5]
    ; draw 'A'
    mov     ecx, 16                         ; height of 'A'
.10L:
    movsb                                   ; *EDI++ = *ESI++
    add     edi, 80 - 1                     ; to the next line of 'A'
    loop    .10L


    ; while(1)
    jmp     $


ALIGN 4, db 0
FONT_ADR:   dd  0

; --- padding ---
    times KERNEL_SIZE - ($ - $$) db 0x00
