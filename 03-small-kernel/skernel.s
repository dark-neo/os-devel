
	# skernel.s
	# dark_neo
	# 2014-08-21

	# Compile with:
	#	as -o skernel.o skernel.s
	#	ld -Ttext 0x07C00 -o skernel.out skernel.o
	#	objcopy -O binary -j .text skernel.out skernel.bin

	.att_syntax
	.code16

	.text

	.global _start

_start:
	xor	%ax,		%ax
	mov	%cs,		%ax		# cs = 0x0
	mov	%ax,		%ds		# ds = 0x0
	mov	%ax,		%es		# es = 0x0
	mov	%ax,		%ss		# ss = 0x0

	lea	welc,		%si
	call	printscr

	_start.loop:
	lea	prompt,		%si
	call	printscr

	mov	buffer,		%di
	call	getinput

	jmp	_start.loop


	.include "incl/sio.s"
	.include "incl/stext/skernel.s"

	
	# create a buffer up 64 characters.
buffer:		.fill	0x00, 64, 0x1

	
	# end
	.fill	0x1FE-(.-_start), 0x1, 0x0
	.int	0xAA55
