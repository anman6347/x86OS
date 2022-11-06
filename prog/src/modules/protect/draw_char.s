; void draw_char(int32 col, int32 row, int32 color, int32 ch);

; display one specified character at the specified location


; col: column where the character is displayed. this parm must take a value between 0 and 79.
; row: row where the character is displayed. this parm must take a value between 0 and 29.
; col and row is not XY dot of screen

; color : color of the character. this uses only the low order 16 bits
; color = color = |Reserved(0) * 4|back I|back R|back G|back B|Reserved(0) * 3|Transmission flag for front character|front I|front R|front G|front B|
; ch: ASCII character code

draw_char:
    ; build stack frame
    push    ebp
    mov     ebp, esp

    ; save registers' data
    push    eax
    push    ebx
    push    ecx
    push    edx
    push    esi
    push    edi


    ; get font address
    movzx   esi, byte [ebp + 20]
    shl     esi, 4                      ; ESI *= 16, size of character = 16byte
    add     esi, [FONT_ADR]


    ; get vram address where the character will be wrote
    ; 0xA0000 + (640 / 8) * 16 * y + x, x = col, y = row
    mov     edi, [ebp + 12]                 ; EDI = y(row) 
    shl     edi, 8                          ; 80 * 16 = 256 * 5 = 256 * 4 + 256
    lea     edi, [0xA0000 + edi * 4 + edi]
    add     edi, [ebp + 8]                  ; EDI += x(col)


    ; display 1 character
    movzx   ebx, word[ebp + 16]             ; EBX = color
    ; Intensity
    cdecl   vga_set_read_plane, 0x03        
    cdecl   vga_set_write_plane, 0x08
    cdecl   vram_font_copy, esi, edi, 0x08, ebx
    ; Red
    cdecl	vga_set_read_plane, 0x02
    cdecl	vga_set_write_plane, 0x04
    cdecl	vram_font_copy, esi, edi, 0x04, ebx
    ; Green
    cdecl	vga_set_read_plane, 0x01
    cdecl	vga_set_write_plane, 0x02
    cdecl	vram_font_copy, esi, edi, 0x02, ebx
    ; Blue
    cdecl	vga_set_read_plane, 0x00
    cdecl	vga_set_write_plane, 0x01
    cdecl	vram_font_copy, esi, edi, 0x01, ebx


    ; return registers' data
    pop     edi
    pop     esi
    pop     edx
    pop     ecx
    pop     ebx
    pop     eax


    ; destroy stack frame
    mov     esp, ebp
    pop     ebp

    ret
