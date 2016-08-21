
	# boot.s
	# dark_neo
	# 2014-08-20

	# Compile with:
	#	as -o boot.o boot.s
	#	ld -Ttext 0x07C00 -o boot.out boot.o
	#	objcopy -O binary -j .text boot.out boot.bin

	.code16				# 16 bits mode
	.att_syntax			# AT&T syntax by default

	/*
	AT&T syntax is much different to Intel syntax. Register's storage is:
		OPERATOR	DESTINATION	SOURCE
	Ex:
		mov		%ax,		%ds

	meaning:
		Store	%ds	on 	%ax

	and registers always wear the '%' prefix.
	*/
	

	.text
	.org	0x0

	LOAD_SEGMENT = 0x1000		


	.globl	main

main:
	jmp	start
	nop


	.func printstr
printstr:
	lodsb					# load byte at ds:si into al
	or	%al,		%al		# test if character is 0 (str end)
	jz	printstr_done			# jump to end if zero
	mov	$0xE,		%ah		# video teletype output
	mov	$0x9,		%bx		# white character
	int	$0x10				# BIOS interrupt
	jmp	printstr			# repeat for next character

printstr_done:
	retw
	.endfunc

	.func reboot
reboot:
	lea	rebootmsg,	%si
	call	printstr			# print rebootmsg data
	xor	%ax,		%ax		# to zero
	int	$0x16				# call bios to wait for key
	.byte	0xEA				# jump to 0x0000FFFF (reboot)
	.word	0x0000
	.word	0xFFFF
	.endfunc
	
start:
	# setup segments:
	cli
	#mov	%dl,		bootdrive	# should be 0x0
	mov	%cs,		%ax		# cs = 0x0
	mov	%ax,		%ds		# ds = cs = 0x0
	mov	%ax,		%es		# es = cs = 0x0
	mov	%ax,		%ss		# ss = cs = 0x0
	mov	$0x7C00,	%sp		# Stack grows down from offset
						# 0x7C00 toward 0x0000
	sti

	# display 'loading' message
	lea	loadmsg,	%si
	call	printstr

	
	# reset hdd
	# jump to bootfail on error
	mov	0x00000000,	%dl		# drive to reset
	xor	%ax,		%ax		# reset to zero
	int	$0x13				# call interrupt 0x00000013
	jc	bootfail			# display error message

	call	reboot

bootfail:
	lea	diskerror,	%si
	call	printstr
	call	reboot

	# program data
loadmsg:	.asciz		"Loading OS...\r\n"
diskerror:	.asciz		"Disk error. "
rebootmsg:	.asciz		"Press any key to reboot.\r\n"

	.fill	0x1FE-(.-main), 0x1, 0x0	# Pad with nulls up to 510 bytes
						# (excl. boot magic)
bootmagic:	.int	0xAA55			# magic word for BIOS
