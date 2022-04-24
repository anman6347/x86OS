    jmp     ipl


    ; BIOS Parameter Block
    times   90 - ($ - $$) db 0x90


    ; Initial Program Loader
ipl:
    jmp     $                       ; while(1);
    times   510 - ($ - $$) db 0x00
    db      0x55, 0xAA              ; boot flag
