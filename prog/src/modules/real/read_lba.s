; int16 read_lba(struct drice *drive, int16 lba, int 16 sect, int16 dst);

; return number of sectors read
; drive: addr to drive struct of drive params
; sect: number of read sectors
; dst: dst addr

; can't call this func before DS = 0, maybe


read_lba:

    ; build stack frame
    push    bp
    mov     bp, sp

    ; save registers
    push    si

    ; get drive params
    mov     si, [bp + 4]

    ; convert to CHS from LBA
    mov     ax, [bp + 6]
    cdecl   lba_chs, si, .chs, ax

    ; copy drive number
    mov     al, [si + drive.no]
    mov     [.chs + drive.no], al

    ; read sectors
    cdecl   read_chs, .chs, word [bp + 8], word [bp + 10]


    ; return registers
    pop     si

    ; destroy stack frame
    mov     sp, bp
    pop     bp

    ret

ALIGN 2
.chs:   times drive_size    db  0x00
