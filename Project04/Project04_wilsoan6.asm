TITLE Accumulator    (Project03.asm)

; Author: Andrew Wilson
; Last Modified: Feb 08, 2019
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
ACCMIN = -100	;minimum value for user input
numberOfNumbers	DWORD	1	;number of integers user has input. Starts at 1 for easy display, needs to be decremented before final display
totalSum		DWORD	0	;tracks total sum of user input
userInput		DWORD	?	;int for storing user input
quotient		DWORD	?	;stores result quotient
remainder		DWORD	?	;stores result remainder
userName		BYTE	33 DUP(0)	;string to be entered by user
intro_1			BYTE	"Welcome to Integer Accumulator by Andrew Wilson ", 0
ec_1			BYTE	"**EC: Numbers the lines during user input", 0
ec_2			BYTE	"**EC: Calculates and displays the average as a floating-point number, rounded to the nearest .001", 0
prompt_1		BYTE	"What's your name? ", 0
intro_2			BYTE	"Nice to meet you, ", 0
prompt_2		BYTE	"Please enter numbers in [-100, -1].", 0
prompt_3		BYTE	"Enter a non-negative number when you are finished to see results.", 0
prompt_4		BYTE	". Enter a number : ",0
error_1			BYTE	"Please enter a number between -100 and -1",0
error_2			BYTE	"You didn't enter any valid numbers!",0
result_1		BYTE	"You entered ",0
result_2		BYTE	" valid numbers.",0
result_3		BYTE	"The sum of your valid numbers is ",0
result_4		BYTE	"The average is ",0
goodBye			BYTE	"Thank you for playing Integer Accumulator! It's been a pleasure to meet you,  ", 0

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

; userInstructions (prompt the user to enter numbers to be accumulated)
	mov		edx, OFFSET	prompt_2
	call	WriteString
	call	crlf
	mov		edx, OFFSET	prompt_3
	call	WriteString
	call	crlf
RepromptInput:
	mov		eax, numberOfNumbers
	call	WriteDec
	mov		edx, OFFSET	prompt_4
	call	WriteString
	call	ReadInt
	mov		userInput, eax			

; dataValidation (validate the input)
	mov		eax, userInput
	mov		ebx, ACCMIN
	cmp		eax, ebx
	jl		NumberTooLow
	add		userInput, 0			;checks if input is negative
	jns		DoTheMathNow			;jumps to calculations if not signed
	jmp		InputGood
NumberTooLow:
	mov		edx, OFFSET	error_1
	call	WriteString
	call	crlf
	jmp		RepromptInput
InputGood:
	mov		eax, userInput
	add		totalSum, eax			;add user input to total sum
	mov		eax, numberOfNumbers
	inc		eax
	mov		numberOfNumbers, eax	;increment input count tracker
	jmp		RepromptInput

; displayResults (calculate and display the numbers)
DoTheMathNow:
	mov		eax, numberOfNumbers
	dec		eax
	mov		numberOfNumbers, eax	;decrement input count tracker because we started at 1
	cmp		numberofNumbers, 0
	jz		noNumbersEntered		;check if user entered any valid numbers. if not, display error and end

	neg		totalSum				;make totalSum positive to facilitate division
	mov		eax, totalSum			
	mov		ebx, numberOfNumbers
	cdq
	div		ebx
	mov		quotient, eax
	mov		remainder, edx

	mov		eax, remainder			;multiplying the remainder by 1000
	mov		ebx, 1000
	mul		ebx
	mov		remainder, eax
	mov		eax, remainder			;then dividing it by numberOfNumbers
	mov		ebx, numberOfNumbers
	cdq
	div		ebx
	mov		remainder, eax			;gives the first three digits after the decimal point

	neg		totalSum				;make totalSum negative (again) for display
	neg		quotient				;make quotient negative for display

	call	crlf
	mov		edx, OFFSET	result_1
	call	WriteString
	mov		eax, numberOfNumbers
	call	WriteDec
	mov		edx, OFFSET	result_2
	call	WriteString
	call	crlf
	mov		edx, OFFSET	result_3
	call	WriteString
	mov		eax, totalSum
	call	WriteInt
	call	crlf
	mov		edx, OFFSET	result_4
	call	WriteString
	mov		eax, quotient
	call	WriteInt
	mov		eax, 46				;ASCII '.'
	call	WriteChar

	mov		eax, remainder	;if the decimal starts with 0 (eg 1.025) we need to add a 0 to the output window
	CMP		eax, 100
	jl		less_than_100
	jmp		not_less_than_100
	
less_than_100: 
	mov		eax, 48				;ASCII '0'
	call	WriteChar

	mov		eax, remainder	;if the decimal starts with 00 (eg 1.005) we need to add another 0
	CMP		eax, 10
	jl		less_than_10
	jmp		not_less_than_100
less_than_10:
	mov		eax, 48				;ASCII '0'
	call	WriteChar

not_less_than_100:
	mov		eax, remainder
	call	WriteDec
	call	crlf

	jmp		SayGoodbye

NoNumbersEntered:
	mov		edx, OFFSET	error_2
	call	WriteString
	call	crlf	

SayGoodbye:
	mov		edx, OFFSET	goodBye
	call	WriteString
	mov		edx, OFFSET	userName
	call	WriteString	
	call	crlf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
