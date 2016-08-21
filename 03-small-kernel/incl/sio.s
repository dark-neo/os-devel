
	# sio.s
	# dark_neo
	# 2014-08-22

	# Compile with:
	#	NOT COMPILE!! ONLY INCLUDE

	###########################
	# Input/Output procedures #
	###########################

	.att_syntax
	.code16
	.text

	.func	printscr
printscr:
	lodsb
	or	%al,		%al
	jz	printscr.done

	mov	$0x0E,		%ah		# enable teletype output
	mov	$0x09,		%bx		# white character
	int	$0x10				# BIOS interrupt
	jmp	printscr

	printscr.done:
	retw
	.endfunc

	
	 # Read char-by-char
	.func getinput
getinput:
	xor	%cl,		%cl		# character counter
	
	getinput.loop:
	mov	$0x00,		%ah
	int	$0x16				# wait for keypress

	cmp	$0x08,		%al		# backspace pressed?
	je	getinput.bckspc			# yes, handle it

	cmp	$0x0D,		%al		# enter pressed?
	je	getinput.done			# yes, we're done

	cmp	$0x3F,		%cl		# 63 characters inpputed?
	je	getinput.loop			# yes, only let backspace and
						# enter

	mov	$0x0E,		%ah		# enable teletype output
	int	$0x10				# BIOS interrupt

	stosb					# put character on buffer
	inc	%cl
	jmp	getinput.loop

	getinput.bckspc:
	cmp	$0x0,		%cl		# beginnig of string?
	je	getinput.loop			# yes, ignore backspace

	dec	%di
	mov	$0x0,		%di		# delete character
	dec	%cl				# decrement character counter

	mov	$0x0E,		%ah		# enable teletype output
	mov	$0x08,		%al		# backspace pressed
	int	$0x10				# backspace on the screen

	mov	$0x00,		%al		# blank character
	int	$0x10				# print on the screen

	mov	$0x08,		%al		# backspace again
	int	$0x10				# BIOS interrupt

	jmp	getinput.loop
	
	getinput.done:
	mov	$0x00,		%al		# null terminator
	stosb

	mov	$0x0E,		%ah		# enable teletype output
	mov	$0x0D,		%al
	int	$0x10				# BIOS interrupt
	mov	$0x0A,		%al		# new line
	int	$0x10

	ret	
	.endfunc
