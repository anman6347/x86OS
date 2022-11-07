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


FAT_SIZE			equ		(1024 * 128)
ROOT_SIZE			equ		(1024 *  16)

FAT_OFFSET			equ		(BOOT_SIZE + KERNEL_SIZE)
; fat.s will be included by kernel.s, and kernel.s and boot.s will be translated into machine language "SEPARATELY".
; Thus, BOOT_SIZE is ignored.
FAT1_START			equ		(KERNEL_SIZE)
FAT2_START			equ		(FAT1_START + FAT_SIZE)
ROOT_START			equ		(FAT2_START + FAT_SIZE)
FILE_START			equ		(ROOT_START + ROOT_SIZE)
; file attribute types
ATTR_READ_ONLY		equ		0x01
ATTR_HIDDEN			equ		0x02
ATTR_SYSTEM			equ		0x04
ATTR_VOLUME_ID		equ		0x08
ATTR_DIRECTORY		equ		0x10
ATTR_ARCHIVE		equ		0x20