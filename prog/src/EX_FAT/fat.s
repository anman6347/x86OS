; ----------------------------
; ---------- FAT 1 -----------
; ----------------------------
times (FAT1_START) - ($ - $$)   db  0x00

FAT1:
    db  0xFF, 0xFF              ; cluster 0 : 0xFF, media type(not used)
    dw  0xFFFF                  ; cluster 1
    dw  0xFFFF                  ; cluster 2

; ----------------------------
; ---------- FAT 2 -----------
; ----------------------------
times (FAT2_START) - ($ - $$)   db  0x00

FAT2:
    db  0xFF, 0xFF              ; cluster 0 : 0xFF, media type(not used)
    dw  0xFFFF                  ; cluster 1
    dw  0xFFFF                  ; cluster 2


; ----------------------------
; -- Root Directory Region ---
; ----------------------------
times (ROOT_START) - ($ - $$)   db  0x00

FAT_ROOT:
    db  "BOOTABLE", "DSK"                   ; DIR_Name
    db  ATTR_ARCHIVE | ATTR_VOLUME_ID       ; DIR_Attr
    db  0x00                                ; DIR_NTRes
    db  0x00                                ; DIR_CrtTimeTenth
    dw  ( 0 << 11) | ( 0 << 5) | (0 / 2)    ; DIR_CrtTime
    dw  ( 0 <<  9) | ( 0 << 5) | ( 1)       ; DIR_CrtDate
    dw  ( 0 <<  9) | ( 0 << 5) | ( 1)       ; DIR_LstAccDate
    dw  0x0000                              ; DIR_FstClusHI
    dw  ( 0 << 11) | ( 0 << 5) | (0 / 2)    ; DIR_WrtTime
    dw  ( 0 <<  9) | ( 0 << 5) | ( 1)       ; DIR_WrtDate
    dw  0                                   ; DIR_FstClusLO 
    dd  0                                   ; DIR_FileSize

    db  "SPECIAL ", "TXT"                   ; DIR_Name
    db  ATTR_ARCHIVE                        ; DIR_Attr
    db  0x00                                ; DIR_NTRes
    db  0x00                                ; DIR_CrtTimeTenth
    dw  ( 0 << 11) | ( 0 << 5) | (0 / 2)    ; DIR_CrtTime
    dw  ( 0 <<  9) | ( 1 << 5) | ( 1)       ; DIR_CrtDate
    dw  ( 0 <<  9) | ( 1 << 5) | ( 1)       ; DIR_LstAccDate
    dw  0x0000                              ; DIR_FstClusHI
    dw  ( 0 << 11) | ( 0 << 5) | (0 / 2)    ; DIR_WrtTime
    dw  ( 0 <<  9) | ( 1 << 5) | ( 1)       ; DIR_WrtDate
    dw  2                                   ; DIR_FstClusLO 
    dd  FILE.end - FILE                     ; DIR_FileSize


; ------------------------------
; File and Directory Data Region
; ------------------------------
times FILE_START - ($ - $$) db  0x00

FILE:
    db  "HELLO, FAT!"
.end:
    db  0
ALIGN 512, db 0x00

times (512 * 63)    db  0x00
