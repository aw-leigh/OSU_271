TITLE Simple Arithmetic     (Project01.asm)

; Author: Andrew Wilson
; Last Modified: Jan 11, 2019
; OSU email address: wilsoan6@oregonstate.edu
; Course number/section: 271-400
; Project Number: #1                Due Date: Jan 21, 2019
; Description: This program will display the program title and programmer name,
;			   display instructions for the user, prompt for two numbers, then
;			   calculate the sum, difference, product, quotient and remainder of the numbers.

INCLUDE Irvine32.inc

.data

number_1		DWORD	?	;integer to be entered by user
number_2		DWORD	?	;integer to be entered by user
repeat_choice	DWORD	?	;stores users answer to repeat prompt
sum				DWORD	?
difference		DWORD	?
product			DWORD	?
quotient		DWORD	?
remainder		DWORD	?
f_remainder		DWORD	?
intro_1			BYTE	"     Simple Arithmetic     by Andrew Wilson ", 0
ec_1			BYTE	"**EC: Repeats until the user chooses to quit.",0
ec_2			BYTE	"**EC: Program verifies second number less than first.",0
ec_3			BYTE	"**EC: Program displays the quotient as a floating-point number, rounded to the nearest .001.",0
intro_2			BYTE	"Enter two numbers and I'll show you the sum, difference, product, quotient and remainder.", 0
prompt_1		BYTE	"First number: ", 0
prompt_2		BYTE	"Second number: ", 0
prompt_error	BYTE	"The second number must be less than the first!",0
sum_string		BYTE	" + ", 0
diff_string		BYTE	" - ", 0
prod_string		BYTE	" x ", 0
quot_string		BYTE	" ", 246, " ", 0	;246 is the ÷ symbol
eqal_string		BYTE	" = ", 0
rem_string		BYTE	", remainder ", 0
dec_string_1	BYTE	"   (To the nearest thousandth, that's ",0
dec_dot			BYTE	".",0
dec_zero		BYTE	"0",0
dec_string_2	BYTE	")",0
repeat_1		BYTE	"If you would like to quit, enter 1", 0
repeat_2		BYTE	"Otherwise, enter any other number to compare two more numbers", 0
goodBye			BYTE	"Goodbye!", 0


.code
main PROC

;Introduce programmer and display program name
	mov		edx, OFFSET	intro_1
	call	WriteString
	call	crlf
	mov		edx, OFFSET	ec_1
	call	WriteString
	call	crlf
	mov		edx, OFFSET	ec_2
	call	WriteString
	call	crlf
	mov		edx, OFFSET	ec_3
	call	WriteString
	call	crlf
	call	crlf

repeat_entrypoint:	;jump here if user repeats/enters wrong values

;display instructions for the user
	mov		edx, OFFSET	intro_2
	call	WriteString
	call	crlf
	call	crlf

;prompt for two numbers
	mov		edx, OFFSET	prompt_1
	call	WriteString
	call	ReadInt
	mov		number_1, eax

	mov		edx, OFFSET	prompt_2
	call	WriteString
	call	ReadInt
	mov		number_2, eax
	call	crlf

;validate that the first number is greater than the second
	mov		eax, number_1	
	CMP		eax, number_2
	jle		number_too_big
	jmp		everything_is_fine

	;if the second number is equal to or greater than the first, display the error and jump back to initial promot
	number_too_big: 
		mov		edx, OFFSET	prompt_error
		call	WriteString
		call	crlf
		call	crlf
		jmp		repeat_entrypoint

	;if the second number is smaller than the first, keep going
	everything_is_fine:

;calculate sum
	mov		eax, number_1
	add		eax, number_2
	mov		sum, eax
;display sum
	mov		eax, number_1
	call	WriteDec
	mov		edx, OFFSET	sum_string
	call	WriteString
	mov		eax, number_2
	call	WriteDec
	mov		edx, OFFSET	eqal_string
	call	WriteString
	mov		eax, sum
	call	WriteDec
	call	crlf

;calculate difference
	mov		eax, number_1
	sub		eax, number_2
	mov		difference, eax	
;display difference
	mov		eax, number_1
	call	WriteDec
	mov		edx, OFFSET	diff_string
	call	WriteString
	mov		eax, number_2
	call	WriteDec
	mov		edx, OFFSET	eqal_string
	call	WriteString
	mov		eax, difference
	call	WriteDec
	call	crlf

;calculate product 
	mov		eax, number_1
	mov		ebx, number_2
	mul		ebx
	mov		quotient, eax
;display product
	mov		eax, number_1
	call	WriteDec
	mov		edx, OFFSET	prod_string
	call	WriteString
	mov		eax, number_2
	call	WriteDec
	mov		edx, OFFSET	eqal_string
	call	WriteString
	mov		eax, quotient
	call	WriteDec
	call	crlf

;calculate quotient and remainder
	mov		eax, number_1
	mov		ebx, number_2
	cdq
	div		ebx
	mov		quotient, eax
	mov		remainder, edx


;display quotient and remainder
	mov		eax, number_1
	call	WriteDec
	mov		edx, OFFSET	quot_string
	call	WriteString
	mov		eax, number_2
	call	WriteDec
	mov		edx, OFFSET	eqal_string
	call	WriteString
	mov		eax, quotient
	call	WriteDec
	mov		edx, OFFSET	rem_string
	call	WriteString
	mov		eax, remainder
	call	WriteDec

;calculate floating-point remainder

	mov		eax, remainder		;multiplying the remainder by 1000
	mov		ebx, 1000
	mul		ebx
	mov		f_remainder, eax
	mov		eax, f_remainder	;then dividing it by number_2
	mov		ebx, number_2
	cdq
	div		ebx
	mov		f_remainder, eax	;gives the first three digits after the decimal point


;display floating-point quotient
	mov		edx, OFFSET	dec_string_1
	call	WriteString
	mov		eax, quotient
	call	WriteDec
	mov		edx, OFFSET	dec_dot
	call	WriteString

	
	mov		eax, f_remainder	;if the decimal starts with 0 (eg 1.025) we need to add a 0 to the output window
	CMP		eax, 100
	jl		less_than_100
	jmp		not_less_than_100
	
	less_than_100: 
		mov		edx, OFFSET	dec_zero
		call	WriteString

	not_less_than_100:

	mov		eax, f_remainder
	call	WriteDec
	mov		edx, OFFSET	dec_string_2
	call	WriteString

	call	crlf
	call	crlf

;ask if user wants to quit or repeat
	mov		edx, OFFSET	repeat_1
	call	WriteString
	call	crlf
	mov		edx, OFFSET	repeat_2
	call	WriteString
	call	crlf

;reads user input, repeating the program unless '1' is entered
	call	ReadInt
	call	crlf
	mov		repeat_choice, eax
	CMP		eax, 1
	jne		repeat_entrypoint

;Say goodbye
	mov		edx, OFFSET	goodBye
	call	WriteString
	call	crlf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
