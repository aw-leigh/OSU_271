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

numberOfNumbers	DWORD	?	;integer to be entered by user
leftNumber		DWORD	0	;initial values for Fibonacci sequence
rightNumber		DWORD	1	;initial values for Fibonacci sequence
tempNumber		DWORD	?	;for swapping left and right
count			DWORD	0	;for counting within loop
userName		BYTE	33 DUP(0)	;string to be entered by user
intro_1			BYTE	"     Fibonacci Numbers     by Andrew Wilson ", 0
ec_1			BYTE	"**EC: Displays results in neat columns", 0
prompt_1		BYTE	"What's your name? ", 0
intro_2			BYTE	"Nice to meet you, ", 0
prompt_2		BYTE	"How many numbers would you like to calculate? (1-46)", 0
error_1			BYTE	"Please enter a number between 1-46",0
five_spaces		BYTE	"     ",0
goodBye			BYTE	"Goodbye, ", 0

.code
main PROC

; display the program title and programmer name
	mov		edx, OFFSET	intro_1
	call	WriteString
	call	crlf
	mov		edx, OFFSET	ec_1
	call	WriteString
	call	crlf
	call	crlf

; get the user's name and greet the user
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

; prompt the user to enter the number of Fibonacci numbers to be displayed (1-46)
RepromptInput:
	mov		edx, OFFSET	prompt_2
	call	WriteString
	call	crlf
	call	ReadInt
	mov		numberOfNumbers, eax

; validate the input
	mov		eax, numberOfNumbers
	mov		ebx, 1
	cmp		eax, ebx
	jb		NumberTooLow
	mov		ebx, 46
	cmp		eax, ebx
	jbe		InputGood
NumberTooLow:
	mov		edx, OFFSET	error_1
	call	WriteString
	call	crlf
	call	crlf
	jmp		RepromptInput

; calculate and display the numbers up to and including the nth term
InputGood:
	call	crlf
	mov		ecx, numberOfNumbers
top:
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

	inc		count				;check if count is divisible by 5
	mov		eax, count
	mov		ebx, 5
	cdq
	div		ebx
	cmp		edx, 0
	je		DivisibleBy5
	jmp		NotDivisibleBy5

DivisibleBy5:					;if count is divisible by 5, newline, except if 40 or more
	mov		eax, count
	cmp		eax, 40				
	jge		NoNewline
	call	crlf
NoNewline:
	loop	top	
	jmp		LoopFinished

NotDivisibleBy5:				;if count less than 35, tab. Otherwise, nothing
	mov		ebx, count
	cmp		ebx, 35
	jg		MoreThan35
	jmp		LessThan35

LessThan35:						
	mov		eax, 9	
	call	WriteChar
	loop	top
	jmp		LoopFinished

MoreThan35:						
	jmp		NoNewline			;we should have "loop	top" here but it is too by 2 byes.
								;Instead we jump to NoNewLine because all it does is loop
								;and jump to the end if loop is finished

;display a parting message to the user by name.
LoopFinished:
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
