; defines of important constants

SECT_SIZE   equ     (512)                       ; size of a sector


BOOT_LOAD   equ     0x7c00                      ; addr where boot program loaded
BOOT_SIZE   equ     (1024 * 8)                  ; size of boot code
BOOT_SECT   equ     (BOOT_SIZE / SECT_SIZE)     ; number of sectors used in boot program
BOOT_END    equ     (BOOT_LOAD + BOOT_SIZE)     ; the end of boot code

E820_RECORD_SIZE    equ     20                  ; the record size (size of buffer for result) used in INT 0x15, EAX = 0xE820


KERNEL_LOAD equ     0x0010_1000                 ; addr where the kernel loaded
KERNEL_SIZE equ     (1024 * 8)                  ; size of the kernel
KERNEL_SECT equ     (KERNEL_SIZE / SECT_SIZE)   ; number of sectors used in kernel
