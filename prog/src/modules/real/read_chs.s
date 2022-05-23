; int read_chs(int drive, int sect, int dst)
; return number of sectors read
; drive: addr to drive struct
; sect: number of read sectors
; dst: dst addr

read_chs:

    ; build stack frame
    push    bp
    mov     bp, sp
    push    3           ; number of retries
    push    0           ; number of ectors read

    ; save registers
    push    ax
    push    bx
    push    cx
    push    dx
    push    es
    push    si

    ; si = addr to drive struct
    mov     si, [bp + 4]
    ; set cx for reading sectors
    
    


    ; return registers
    pop     bx
    pop     ax

    ; destroy stack frame
    mov     sp, bp
    pop     bp

    ret
