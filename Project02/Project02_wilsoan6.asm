TITLE Fibonacci    (Project02.asm)

; Author: Andrew Wilson
; Last Modified: Jan 23, 2019
; OSU email address: wilsoan6@oregonstate.edu
; Course number/section: 271-400
; Project Number: #2                Due Date: Jan 27, 2019
; Description: This program will display the program title and programmer name,
;			   get the user's name and greet the user, then prompt the user to enter the number of
;			   Fibonacci numbers to be displayed (1-46).
;			   It will get and validate the input, calculate and display the numbers up to and including the nth term.
;			   The results will be displayed 5 terms per line with 5 spaces separating each.
;			   It will then display a parting message to the user by name.

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data
FIBMAX = 46	;maximum value for user input
FIBMIN = 1	;minimum value for user input
numberOfNumbers	DWORD	?	;integer to be entered by user
leftNumber		DWORD	0	;initial values for Fibonacci sequence
rightNumber		DWORD	1	;initial values for Fibonacci sequence
tempNumber		DWORD	?	;for swapping left and right
count			DWORD	0	;for counting within loop
userName		BYTE	33 DUP(0)	;string to be entered by user
intro_1			BYTE	"     Fibonacci Numbers     by Andrew Wilson ", 0
ec_1			BYTE	"**EC: Displays results in neat columns", 0
ec_2			BYTE	"**EC: Displays results in INCREDIBLE TECHNICOLOR", 0
prompt_1		BYTE	"What's your name? ", 0
intro_2			BYTE	"Nice to meet you, ", 0
prompt_2		BYTE	"This program displays Fibonacci numbers!", 0
prompt_3		BYTE	"How many numbers would you like to calculate? (1-", 0
prompt_4		BYTE	")",0
error_1			BYTE	"Please enter a number between 1-46",0
five_spaces		BYTE	"     ",0
goodBye			BYTE	"Goodbye, ", 0

.code
main PROC

; Introduction (display the program title and programmer name)
	mov		edx, OFFSET	intro_1
	call	WriteString
	call	crlf
	mov		edx, OFFSET	ec_1
	call	WriteString
	call	crlf
	mov		edx, OFFSET	ec_2
	call	WriteString
	call	crlf
	call	crlf

; getUserData (get the user's name and greet the user)
	mov		edx, OFFSET	prompt_1
	call	WriteString
	mov		edx, OFFSET	userName
	mov		ecx, 32
	call	ReadString
	call	crlf
	mov		edx, OFFSET	intro_2
	call	WriteString	
	mov		edx, OFFSET	userName
	call	WriteString	
	call	crlf
	call	crlf

; userInstructions (prompt the user to enter the number of Fibonacci numbers to be displayed (1-46))
RepromptInput:
	mov		edx, OFFSET	prompt_2
	call	WriteString
	call	crlf
	mov		edx, OFFSET	prompt_3
	call	WriteString
	mov		eax, FIBMAX
	call	WriteDec
	mov		edx, OFFSET	prompt_4
	call	WriteString
	call	crlf
	call	ReadInt
	mov		numberOfNumbers, eax

; dataValidation (validate the input)
	mov		eax, numberOfNumbers
	mov		ebx, FIBMIN
	cmp		eax, ebx
	jb		NumberTooLow
	mov		ebx, FIBMAX
	cmp		eax, ebx
	jbe		InputGood
NumberTooLow:
	mov		edx, OFFSET	error_1
	call	WriteString
	call	crlf
	call	crlf
	jmp		RepromptInput

; displayFibs (calculate and display the numbers up to and including the nth term)
InputGood:
	call	crlf
	mov		ecx, numberOfNumbers

top:
	inc		count
	mov		eax, count
	test	ax, 1				;test if even or odd to deterine color (LSB is 1 or 0)
	jnz		Color1
	jz		Color2
Color1:
	mov		eax, lightgreen + (green * 16)	;change text color, just for fun
	call	SetTextColor
	jmp		FinishedWithColors
Color2:
	mov		eax, lightblue + (blue * 16)	;change text color, just for fun
	call	SetTextColor

FinishedWithColors:
	mov		eax, rightNumber	;display current number
	call	WriteDec

	add		eax, leftNumber		;calculate and store next values
	mov		tempNumber, eax
	mov		eax, rightNumber
	mov		leftNumber, eax
	mov		eax, tempNumber
	mov		rightNumber, eax

	mov		eax, 9				;9 is ASCII tab, used to space columns
	call	WriteChar
	call	WriteChar

	mov		eax, count			;check if count is divisible by 5
	mov		ebx, 5
	cdq
	div		ebx
	cmp		edx, 0
	je		DivisibleBy5
	jmp		NotDivisibleBy5
LoopTooFarAway:
	loop	top
	jmp		LoopFinished

DivisibleBy5:					;if count is divisible by 5, newline, except if 40 or more,
	mov		eax, count			;because of the default console window size
	cmp		eax, 40				
	jge		NoNewline
	call	crlf
NoNewline:
	jmp		LoopTooFarAway		;Ideally would be "loop	top" but it's too far away


NotDivisibleBy5:				;if count less than 35, tab. Otherwise, nothing
	mov		ebx, count
	cmp		ebx, 35
	jg		MoreThan35
	jmp		LessThan35
LessThan35:						
	mov		eax, 9	
	call	WriteChar
MoreThan35:						
	jmp		LoopTooFarAway		;Ideally would be "loop	top" but it's too far away


;farewell (display a parting message to the user by name)
LoopFinished:
	mov		eax, lightgray + (black * 16) ;change text color, just for fun
	call	SetTextColor
	call	crlf
	call	crlf
	mov		edx, OFFSET	goodBye
	call	WriteString
	mov		edx, OFFSET	userName
	call	WriteString	
	call	crlf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
