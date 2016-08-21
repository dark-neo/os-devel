
; boot.asm
; dark_neo
; 2014-08-19

; Compile with:
;       nasm -f bin boot.asm

; Same example of *00-first-example* but using procedures.

[BITS 16]
[ORG 0x00007C00]                ; The BIOS *will always* load the boot sector
                                ; starting at this memory location. But, by
                                ; default, the start of a raw binary is at
                                ; offset 0x0, so you need force it.

section .text
section .data
        msg     db      "Hello world", 0xD, 0xA, 0x0

global  _start

_start:
        ; *IMPORTANT*
        ; Force to load the boot sector at 0x0:0x00007C00
        xor     ax,     ax              ; make it zero.
        mov     ds,     ax
        mov     si,     msg
        call    bios_print

hang:
        jmp     hang

bios_print:
        lodsb
        or      al,     al              ; zero = end of string
        jz      done                    ; get out
        mov     ah,     0x0E
        int     0x10                    ; 0x10 = 16 decimal
        jmp     bios_print
done:
        ret

        times   0x1FE-($-$$) db 0x0
        db      0x55
        db      0xAA
