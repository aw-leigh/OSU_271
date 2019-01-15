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

number_1	DWORD	?	;integer to be entered by user
number_2	DWORD	?	;integer to be entered by user
sum			DWORD	?
difference	DWORD	?
product		DWORD	?
quotient	DWORD	?
remainder	DWORD	?
intro_1		BYTE	"     Simple Arithmetic     by Andrew Wilson ", 0
intro_2		BYTE	"Enter two numbers and I'll show you the sum, difference, product, quotient and remainder.", 0
prompt_1	BYTE	"First number: ", 0
prompt_2	BYTE	"Second number: ", 0
sum_string	BYTE	" + ", 0
diff_string	BYTE	" - ", 0
prod_string	BYTE	" x ", 0
quot_string	BYTE	" ", 246, " ", 0	;246 is the ÷ symbol
eqal_string	BYTE	" = ", 0
rem_string	BYTE	", remainder ", 0
goodBye		BYTE	"Goodbye!", 0


.code
main PROC

;Introduce programmer and display program name
	mov		edx, OFFSET	intro_1
	call	WriteString
	call	crlf
	call	crlf

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

;calculate and display sum
	mov		eax, number_1
	add		eax, number_2
	mov		sum, eax

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

;calculate and display difference
	mov		eax, number_1
	sub		eax, number_2
	mov		difference, eax	

	mov		eax, number_1
	call	WriteDec
	mov		edx, OFFSET	diff_string
	call	WriteString
	mov		eax, number_2
	call	WriteDec
	mov		edx, OFFSET	eqal_string
	call	WriteString
	mov		eax, difference
	call	WriteInt
	call	crlf

;calculate and display product
	mov		eax, number_1
	mov		ebx, number_2
	mul		ebx
	mov		quotient, eax

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


;calculate and display quotient and remainder
	mov		eax, number_1
	mov		ebx, number_2
	cdq
	div		ebx
	mov		quotient, eax
	mov		remainder, edx

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
	call	crlf
	call	crlf


;Say goodbye
	mov		edx, OFFSET	goodBye
	call	WriteString
	call	crlf
	
	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
