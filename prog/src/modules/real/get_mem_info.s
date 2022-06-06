; void get_mem_info(void)
; get mem info using INT 0x15, EAX = 0xE820, and store ACPI info in ACPI_DATA in the global area


get_mem_info:

    ; save registers
    push    eax
    push    ebx
    push    ecx
    push    edx
    push    si
    push    di
    push    bp

    cdecl   puts, .s0
    mov     bp, 0                       ; line = 0;
    mov     ebx, 0                      ; continuation value or zero to start at beginning of map
.10L:                                                                                   ; do {
    mov     eax, 0xE820
    mov     ecx, E820_RECORD_SIZE       ; size of buffer for result, in bytes
    mov     edx, 'PAMS'                 ; edx = 'SMAP'
    mov     di, .b0                     ; ES:DI -> buffer for result
    int     0x15                        ; Newer BIOSes - GET SYSTEM MEMORY MAP

    ; Is the BIOS support this interrupt service?
    cmp     eax, 'PAMS'
    je      .12E
    jmp     .10E
.12E:
    ; error check
    jnc     .14E
    jmp     .10E

.14E:
    cdecl   put_mem_info, di            ; display mem info of one record

    ; get addrs of ACPI data 
    mov     eax, [di + 16]              ; eax = data type
    cmp     eax, 3                      ; Is data type ACPI Reclaim Memory?
    jne     .15E

    mov     eax, [di + 0]
    mov     [ACPI_DATA.adr], eax        ; base addr

    mov     eax, [di + 8]
    mov     [ACPI_DATA.len], eax        ; length

.15E:
    ; display a message per 8 lines to prevent the screen from being refleshed
    cmp     ebx, 0                      ; all done?
    jz      .16E

    inc     bp                          ; line++;
    and     bp, 0x07
    jnz     .16E
    ; display a message
    cdecl   puts, .s2

    mov     ah, 0x10
    int     0x16                        ; waiting for key-in

    cdecl   puts, .s3                   ; remove the message 

.16E:
    cmp     ebx, 0
    jne     .10L                                                                                ; } while(0 != ebx)


.10E:
    cdecl   puts, .s1

    ; return registers
    pop     bp
    pop     di
    pop     si
    pop     edx
    pop     ecx
    pop     ebx
    pop     eax


    ret


.s0:	db " E820 Memory Map:", 0x0A, 0x0D
		db " Base_____________ Length___________ Type____", 0x0A, 0x0D, 0
.s1:	db " ----------------- ----------------- --------", 0x0A, 0x0D, 0
.s2:    db  " <more...>", 0
.s3:    db  0x0D, "        ", 0x0D, 0

ALIGN 4,    db  0
.b0:    times   E820_RECORD_SIZE    db  0   ; system memmap buffer


; void put_mem_info(int16 addr)
; nested func

put_mem_info:

    ; build stack frame
    push    bp
    mov     bp, sp

    ; save registers
    push    bx
    push    si

    ; get addr
    mov     si, [bp + 4]

    ; convert mem info from int to str
    ; Base(64bit)
    cdecl   itoa, word  [si + 6], .s2 + 0, 4, 16, 0b0100
    cdecl   itoa, word  [si + 4], .s2 + 4, 4, 16, 0b0100
    cdecl   itoa, word  [si + 2], .s3 + 0, 4, 16, 0b0100
    cdecl   itoa, word  [si + 0], .s3 + 4, 4, 16, 0b0100
    ; Length(64bit)
    cdecl   itoa, word  [si + 14], .s4 + 0, 4, 16, 0b0100
    cdecl   itoa, word  [si + 12], .s4 + 4, 4, 16, 0b0100
    cdecl   itoa, word  [si + 10], .s5 + 0, 4, 16, 0b0100
    cdecl   itoa, word  [si + 8],  .s5 + 4, 4, 16, 0b0100
    ; Type(32bit)
    cdecl   itoa, word  [si + 18], .s6 + 0, 4, 16, 0b0100
    cdecl   itoa, word  [si + 16], .s6 + 4, 4, 16, 0b0100

    cdecl   puts, .s1   ; display mem info(Base, Length)

    mov     bx, [si + 16]
    and     bx, 0x07            ; bx = type 0 ~ 5;
    shl     bx, 1               ; bx *= 2;
    add     bx, .tpstrlist      ; bx += .tpstrlist
    cdecl   puts, word [bx]


    ; return registers
    pop     si
    pop     bx

    ; destroy stack frame
    mov     sp, bp
    pop     bp

    ret


.s1:    db  " "
.s2:    db  "ZZZZZZZZ_"
.s3:    db  "ZZZZZZZZ "
.s4:    db  "ZZZZZZZZ_"
.s5:    db  "ZZZZZZZZ "
.s6:    db  "ZZZZZZZZ", 0

.t0:    db  " (Unknown)", 0x0A, 0x0D, 0
.t1:    db  " (usable)", 0x0A, 0x0D, 0
.t2:    db  " (reserved)", 0x0A, 0x0D, 0
.t3:    db  " (ACPI data)", 0x0A, 0x0D, 0
.t4:    db  " (ACPI NVS)", 0x0A, 0x0D, 0
.t5:    db  " (bad memory)", 0x0A, 0x0D, 0

.tpstrlist: dw  .t0, .t1, .t2, .t3, .t4, .t5, .t0, .t0      ; each of these addresses is 16bit(real mode)
