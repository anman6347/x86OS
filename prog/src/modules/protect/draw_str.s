; void draw_str(int32 col, int32 row, int32 color, int32 p);

; display string

; col: column where the character is displayed. this parm must take a value between 0 and 79.
; row: row where the character is displayed. this parm must take a value between 0 and 29.
; col and row is not XY dot of screen

; color : color of the string. this uses only the low order 16 bits
; color = color = |Reserved(0) * 4|back I|back R|back G|back B|Reserved(0) * 3|Transmission flag for front character|front I|front R|front G|front B|

; p : addr of the string


draw_str:
    ; build stack frame
    push    ebp
    mov     ebp, esp

    ; save registers' data
    push    eax
    push    ebx
    push    ecx
    push    edx
    push    esi

    ; get args
    mov     ecx, [ebp + 8]          ; ECX = x(col);
    mov     edx, [ebp + 12]         ; EDX = y(row);
    movzx   ebx, word [ebp + 16]    ; EBX = color;
    mov     esi, [ebp + 20]         ; ESI = p;

;    push    .DBG
;    pop     esi


    ;mov     esi, [.DBG]
    ;mov     al, [esi]
    ;cdecl   draw_char, ecx, 0, ebx, eax   ;   draw_char();



    ; display string
    cld                                     ; DF = 0;
    mov     eax, 0
.10L:                                       ; do {
    lodsb                                   ;   AL = *(ESI++);

    cmp     al, 0                           ;   if (AL == NULL) break;
    je      .10E
    
    ; display one character
    cdecl   draw_char, ecx, edx, ebx, eax   ;   draw_char();
    
    ; calc the position of next character
    inc     ecx                             ;   ECX++
    cmp     ecx, 80                         ;   if (ECX >= 80) {
    jl      .12E
    mov     ecx, 0                          ;       ECX = 0;
    inc     edx                             ;       EDX++;
    cmp     edx, 30                         ;       if (EDX >= 30) {
    jl      .12E
    mov     edx, 0                          ;           EDX = 0;
                                            ;       }
                                            ;   }
.12E:
    jmp     .10L                            ; } while (1);
.10E:

    ; return registers' data
    pop     esi
    pop     edx
    pop     ecx
    pop     ebx
    pop     eax

    ; destroy stack frame
    mov     esp, ebp
    pop     ebp

    ret
.DBG:   db  'A', 0x00