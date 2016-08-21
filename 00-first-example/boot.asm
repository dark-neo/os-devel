
; boot.asm
; dark_neo
; 2014-08-19

; Compile with:
;       nasm -f bin boot.asm

; Example about boot code.
; NOTE: The *msg* var use BIOS to write his content (Hello world).

[BITS 16]
[ORG 0x00007C00]                ; The BIOS *will always* load the boot sector
                                ; starting at this memory location. But, by
                                ; default, the start of a raw binary is at
                                ; offset 0x0, so you need force it.

section .text
section .data
        msg     db      'Hello world', 0x0D, 0x0A, 0x00

global  _start

_start:
        ; *IMPORTANT*
        ; Force to load the boot sector at 0x0:0x00007C00
        xor     ax,     ax              ; make it zero.
        mov     ds,     ax
        mov     si,     msg
ch_loop:
        lodsb
        or      al,     al      ; zero=end or str
        jz      hang            ; get out
        mov     ah,     0x0E
        int     0x10
        jmp     ch_loop
hang:
        jmp     hang

        ; Fill up 512 bytes with zeros.
        ; 512d == 200 hx
        times   0x1FE-($-$$) db 0x0
        db      0x55
        db      0xAA
