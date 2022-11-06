; void draw_font(int32 col, int32 row);

; display all characters obtained by int 0x10 order

; col: column where the character is displayed. this parm must take a value between 0 and 79.
; row: row where the character is displayed. this parm must take a value between 0 and 29.
; col and row is not XY dot of screen

draw_font:
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

    ; get args
    mov     esi, [ebp + 8]      ; ESI = x(col)
    mov     edi, [ebp + 12]     ; EDI = y(row)

    ; display all characters obtained by int 0x10 order
    mov     ecx, 0
.10L:
    cmp     ecx, 256                            ; while (ECX < 256) {
    jae     .10E 

    ; calc x(col)
    mov     eax, ecx                            ;   EAX = ECX;
    and     eax, 0x0F                           ;   EAX &= 0x0F;
    add     eax, esi                            ;   EAX += x;
    ; calc y(row)
    mov     ebx, ecx                            ;   EBX = ECX;
    shr     ebx, 4                              ;   EBX /= 16;
    add     ebx, edi                            ;   EBX += y;

    cdecl   draw_char, eax, ebx, 0x07, ecx      ;   draw_char();

    inc     ecx                                 ;   ECX++;
    jmp     .10L                                ; }
.10E:

    ; return registers' data
    pop     edx
    pop     eax

    ; destroy stack frame
    mov     esp, ebp
    pop     ebp

    ret

