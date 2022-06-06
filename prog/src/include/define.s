; defines of important constants

BOOT_LOAD   equ     0x7c00                  ; addr where boot program loaded

BOOT_SIZE   equ     (1024 * 8)              ; size of boot code
SECT_SIZE   equ     (512)                   ; size of a sector
BOOT_SECT   equ     (BOOT_SIZE / SECT_SIZE) ; numbaer of sectors used in boot program

E820_RECORD_SIZE    equ     20              ; the record size (size of buffer for result) used in INT 0x15, EAX = 0xE820
