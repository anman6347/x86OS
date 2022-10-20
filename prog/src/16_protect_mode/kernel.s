    ; --- macro ---
    %include    "../include/define.s"
    %include    "../include/macro.s"

    ORG     KERNEL_LOAD

[BITS 32]

    ; --- entry point ---
kernel:
    jmp     $                       ; while(1);


; --- padding ---
    times KERNEL_SIZE - ($ - $$) db 0x00
