; void itos(int num, char* buf, int size, int radix, int flags);
; flags = 1 : num is used as signed
; flags = 2 : display plus/minus sign
; flags = 4 : fill in the space with 0


itoa:
    ; build stack frame
    push    bp
    mov     bp, sp

    ; save registers' data
    push    ax
    push    bx
    push    cx
    push    dx
    push    si
    push    di

    ; get args
    mov     ax, [bp + 4]    ; ax = num;
    mov     si, [bp + 6]    ; si = buf;
    mov     cx, [bp + 8]    ; cx = size;

    mov     di, si
    add     di, cx
    dec     di              ; di = &(buf[size - 1]);

    mov     bx, [bp + 12]   ; bx = flags;

    ; positive/negative judgement
    test    bx, 0b0001      ; if (flags & 0x01)
    je      .10E
    cmp     ax, 0           ;   if (num < 0)
    jge     .12E
    or      bx, 0b0010      ;       flags |= 2;
.10E:
.12E:

    ; which sould be displayed pos/neg ?
    test    bx, 0b0010
    je      .20E
    cmp     ax, 0
    jge     .22F
    neg     ax              ; num *= -1;
    mov     [si], byte '-'  ; buf[0] = '-';
    jmp     .22E
.22F:
    mov     [si], byte '+'
.22E:
    dec     cx
.20E:


    ; convert num to ASCII
    mov     bx, [bp + 10]           ; bx = radix
.30L:
    mov     dx, 0
    div     bx                      ; ax = dx:ax % bx,;     dx = dx:ax % bx;

    mov     si, dx
    mov     dl, byte [.ascii + si]  ; dl = ascii[si];

    mov     [di], dl                ; buf[size - i]
    dec     di

    cmp     ax, 0
    loopnz  .30L


    ; fill in the space
    cmp     cx, 0
    je      .40E
    mov     al, ' '
    test    [bp + 12], word 0b0100  ; if (flags & 0x04)
    je     .42E
    mov     al, '0'
.42E:
    std                             ; DF = 1 (- direction)
    rep stosb                       ; while(--cx) [di--] = al;
.40E:


    ; return registers' data
    pop     di
    pop     si
    pop     dx
    pop     cx
    pop     bx
    pop     ax

    ; destroy stack frame
    mov     sp, bp
    pop     bp

    ret


.ascii: db  "0123456789ABCDEF"      ; ascii-short table

