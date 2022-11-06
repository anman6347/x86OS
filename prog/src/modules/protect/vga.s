; definitions of
; void vga_set_read_plane(int32 plane);
; void vga_set_write_plane(int32 plane);
; void vram_font_copy(int32 font, int32 vram, int32 plane, int32 color)



; --------------------------------------
; void vga_set_read_plane(int32 plane);
; plane : read-plane, uses only the low order 8 bits
; plane = |Reserved(0) * 6 | MAP * 2|
; MAP = 0 ~ 3 (Intensity = 3, R = 2, G = 1, B = 0)

vga_set_read_plane:
    ; build stack frame
    push    ebp
    mov     ebp, esp

    ; save registers' data
    push    eax
    push    edx

    ; select read-plane
    mov     ah, [ebp + 8]       ; AH = read-plane
    and     ah, 0x03
    mov     al, 0x04            ; index of GR04(Read Plane Select Register)
    mov     dx, 0x03CE          ; I/O (or memory) address of GRX(Graphics Controller Index Register)
    out     dx, ax

    ; return registers' data
    pop     edx
    pop     eax

    ; destroy stack frame
    mov     esp, ebp
    pop     ebp

    ret


; --------------------------------------
; void vga_set_read_plane(int32 plane);
; plane : write-plane, uses only the low order 8 bits
; plane = |Reserved(0) * 4 |I|R|G|B|

vga_set_write_plane:
    ; build stack frame
    push    ebp
    mov     ebp, esp

    ; save registers' data
    push    eax
    push    edx

    ; select read-plane
    mov     ah, [ebp + 8]       ; AH = read-plane(Reserved(0) * 4|luminance|R|G|B)
    and     ah, 0x0F
    mov     al, 0x02            ; index of SR02(Plane/Map Mask )
    mov     dx, 0x03C4          ; I/O (or memory) address of SRX(Sequencer Index)
    out     dx, ax

    ; return registers' data
    pop     edx
    pop     eax

    ; destroy stack frame
    mov     esp, ebp
    pop     ebp

    ret


; --------------------------------------
; void vram_font_copy(int32 font, int32 vram, int32 plane, int32 color)
; write font data to selected plane
;
; font : font addr of a character
; vram : vram addr where the character will be wrote
; plane : write-plane, uses only the low order 8 bits
; color : color of character on screen. this uses only the low order 16 bits
; color = |Reserved(0) * 4|back I|back R|back G|back B|Reserved(0) * 3|Transmission flag for front character|front I|front R|front G|front B|

vram_font_copy:
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

    ; get each args
    mov     esi, [ebp + 8]          ; ESI = font addr
    mov     edi, [ebp + 12]         ; EDI = vram addr
    movzx   eax, byte [ebp + 16]    ; EAX = plane
    movzx   ebx, word [ebp + 20]    ; EBX = color

    ; dh = bool of write or not write back image
    test    bh, al                  ; ZF = back color & write-plane
    setz    dh                      ; AH = (ZF ? 1 : 0)
    dec     dh                      ; DH = 0x00 or 0xFF
    ; dl = bool of write or not write front image
    test    bl, al                  ; ZF = front color & write-plane
    setz    dl                      ; AL = (ZF ? 1 : 0)
    dec     dl                      ; DL = 0x00 or 0xFF

    ; copy 16bit font data
    cld
    mov     ecx, 16
.10L:                               ; do {
    lodsb                           ;   AL = *(ESI++);
    mov     ah, al
    not     ah                      ;   make inverted image;

    ; front
    and     al, dl                  ;   if (DL) write front image;

    ; back
    test    ebx, 0x0010             ;   if (Transmission) {
    jz      .11F
    and     ah, [edi]               ;       AH = !image & State before rewriting   
	jmp     .11E                    ;   } else {    
.11F:
    and     ah, dh                  ;       AH = !image & specified background color
                                    ;   }
.11E:
    or      al, ah                  ; AL = front | back


    mov     [edi], al               ; write character or background to VRAM

    add     edi, 80                 ; go to next line
    loop    .10L                    ; } while (--ECX)


    ; return registers' data
    pop		edi
    pop		esi
    pop		edx
    pop		ecx
    pop		ebx
    pop		eax

    ; destroy stack frame
    mov     esp, ebp
    pop     ebp

    ret
