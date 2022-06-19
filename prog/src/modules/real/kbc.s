; definitions of
; int16 KBC_Data_Write(int16 input_data),
; int16 KBC_Data_Read(int16 output_adr),
; int16 KBC_Cmd_Write(int16 cmd)

; --------------------------------------
; int16 KBC_Data_Write(int16 input_data)
; return non-zero on success, and 0 on error 
; input_data : input_data for the buffer in KBC


KBC_Data_Write:

    ; build stack frame
    push    bp
    mov     bp, sp

    ; save registers
    push    cx

    mov     cx, 0           ; cnt = 0;
.10L:                       ; do {
    in      al, 0x64            ; get KBC status

    test    al, 0x02            ; check input buffer status
                                ; must be clear before attempting to write data to IO port 0x60 or IO port 0x64
    loopnz  .10L            ; } while (--CX && !ZF);

    cmp     cx, 0           ; if cnt == 0 again, it means time-out
    jz      .20E            ; if (CX) {
    mov     al, [bp + 4]        ; AL = input_data;
    out     0x60, al            ; outp(0x60, AL);
                            ; }

.20E:
    mov     ax, cx          ; return CX;

    ; return registers
    pop     cx

    ; destroy stack frame
    mov     sp, bp
    pop     bp

    ret


; -----------------------------------
; int16 KBC_Data_Read(int16 output_adr)
; return non-zero on success, and 0 on error 
; output_adr : adr for the data read from KBC buffer

KBC_Data_Read:

    ; build stack frame
    push    bp
    mov     bp, sp

    ; save registers
    push    cx
    push    di

    mov     cx, 0           ; cnt = 0;
.10L:                       ; do {
    in      al, 0x64            ; get KBC status

    test    al, 0x01            ; check output buffer status
                                ; must be set before attempting to read data from IO port 0x60
    loopz   .10L            ; } while (--CX && ZF);

    cmp     cx, 0           ; if cnt == 0 again, it means time-out
    jz      .20E            ; if (CX) {
    mov     ah, 0x00
    in      al, 0x60            ; AL = inp(0x60);
    
    mov     di, [bp + 4]        ; DI = output_adr;
    mov     [di + 0], ax        ; *DI = AX;
                            ; }

.20E:
    mov     ax, cx          ; return CX;

    ; return registers
    pop     di
    pop     cx

    ; destroy stack frame
    mov     sp, bp
    pop     bp

    ret


; ------------------------------
; int16 KBC_Cmd_Write(int16 cmd)
; return non-zero on success, and 0 on error 
; cmd : command sending to KBC

KBC_Cmd_Write:

    ; build stack frame
    push    bp
    mov     bp, sp

    ; save registers
    push    cx

    mov     cx, 0           ; cnt = 0;
.10L:                       ; do {
    in      al, 0x64            ; get KBC status

    test    al, 0x02            ; check input buffer status
                                ; must be clear before attempting to write data to IO port 0x60 or IO port 0x64
    loopnz  .10L            ; } while (--CX && !ZF);

    cmp     cx, 0           ; if cnt == 0 again, it means time-out
    jz      .20E            ; if (CX) {
    mov     al, [bp + 4]        ; AL = input_data;
    out     0x64, al            ; outp(0x60, AL);
                            ; }

.20E:
    mov     ax, cx          ; return CX;

    ; return registers
    pop     cx

    ; destroy stack frame
    mov     sp, bp
    pop     bp

    ret
