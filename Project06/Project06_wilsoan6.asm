TITLE  Designing Lowlevel I/O procedures    (Project06A.asm)

; Author: Andrew Wilson
; Last Modified: Mar 5, 2019
; OSU email address: wilsoan6@oregonstate.edu
; Course number/section: 271-400
; Project Number: #6                Due Date: March 17, 2019
; Description: This program asks the user for 10 unsigned integers, then displays a list
;			   of the integers, their sum, and their average value.

INCLUDE Irvine32.inc

writeStringMacro	MACRO	stringAddress
	push	edx				;Save edx
	mov		edx, stringAddress
	call	WriteString
	pop		edx				;Restore edx
ENDM

getStringMacro	MACRO	promptAddress, inStringAddress, stringLengthAddress

	push	edx				;Save edx
	push	ecx				;save ecx

	writeStringMacro	promptAddress
	mov		edx, inStringAddress
	mov		ecx, MAX_IN_SIZE
	call	ReadString
	mov		stringLengthAddress, eax

	pop		ecx				;Restore ecx
	pop		edx				;Restore edx
ENDM

dotSpace	MACRO

	push	eax				;Save edx
	mov		eax, 46			;ASCII '.'
	call	WriteChar
	mov		eax, 32			;ASCII ' '
	call	WriteChar
	pop		eax				;Restore edx

ENDM

commaSpace	MACRO

	push	eax				;Save edx
	mov		eax, 44			;ASCII ','
	call	WriteChar
	mov		eax, 32			;ASCII ' '
	call	WriteChar
	pop		eax				;Restore edx

ENDM

MAX_IN_SIZE		= 11
MAX_OUT_SIZE	= 11

.data

intro_1			BYTE	"Welcome to Designing low-level I/O procedures     by Andrew Wilson ", 0
intro_2			BYTE	"Please provide 10 unsigned decimal integers.", 0
intro_3			BYTE	"Each number needs to be small enough to fit inside a 32 bit register.", 0
intro_4			BYTE	"After you have finished inputting the raw numbers I will display a list", 0
intro_5			BYTE	"of the integers, their sum, and their average value.", 0
prompt_1		BYTE	"Please enter an unsigned number: ",0
error_1			BYTE	"ERROR: You did not enter an unsigned number or your number was too big.",0
error_2			BYTE	"Please try again: ",0
output_1		BYTE	"You entered the following numbers:",0
output_2		BYTE	"The sum of these numbers is: ",0
output_3		BYTE	"The average is: ",0
inString		BYTE	MAX_IN_SIZE DUP(?)		; User's string
outString		BYTE	MAX_OUT_SIZE DUP(?)		; User's string
arrayOfInts		DWORD	10	DUP(?)			;array of ints
stringLength	DWORD	0
sum				DWORD	0


.code
main PROC

	push	OFFSET intro_1	;24
	push	OFFSET intro_2	;20
	push	OFFSET intro_3	;16
	push	OFFSET intro_4	;12
	push	OFFSET intro_5	;8
	call	introduction

	push	OFFSET stringLength	;28
	push	OFFSET arrayOfInts	;24
	push	OFFSET error_2		;20
	push	OFFSET error_1		;16
	push	OFFSET prompt_1		;12
	push	OFFSET inString		;8
	call	getUserData

	push	OFFSET sum			;12
	push	OFFSET arrayOfInts	;8
	call	calculateSum

	call	crlf
	push	OFFSET output_1		;28
	push	OFFSET output_2		;24
	push	OFFSET output_3		;20
	push	sum					;16
	push	OFFSET arrayOfInts	;12
	push	OFFSET outString	;8
	call	displayData
	
	;mov	eax, sum
	;call	WriteDec

	exit	; exit to operating system
main ENDP

;********************************************************************************************************
;Procedure to introduce the program.
;receives: none
;returns: none
;preconditions:  needs strings called intro_1, intro_2, intro_3, intro_4 and intro_5
;registers changed: edx
;********************************************************************************************************
introduction	PROC
	push	ebp
	mov		ebp, esp

	writeStringMacro [ebp+24]	;@intro_1
	call	crlf
	call	crlf
	writeStringMacro [ebp+20]	;@intro_2
	call	crlf
	writeStringMacro [ebp+16]	;@intro_3
	call	crlf
	writeStringMacro [ebp+12]	;@intro_4
	call	crlf
	writeStringMacro [ebp+8]	;@intro_5
	call	crlf
	call	crlf

	pop		ebp
	ret		20
introduction	ENDP

;********************************************************************************************************
;Procedure to get int data from user. Calls readVal.
;receives: two error prompts, one imput prompt, one DWORD array for storing ints, and one string for reading in keyboard input
;returns: user input values into DWORD array
;preconditions:  push array, error two, error one, prompt, and string in that order
;registers changed: eax, ebx, ecx, edx
;********************************************************************************************************
getUserData	PROC
	push	ebp
	mov		ebp, esp
	push	ecx			;save ecx

	mov		ecx, 10		;need to get 10 ints
top:
	push	[ebp+28]	;@stringLength	
	mov		eax, 10		;(10 - edx) * 4 = offset from front of array of leftmost open space
	sub		eax, ecx
	mov		ebx, 4
	mul		ebx
	add		eax, [ebp+24] ;@arrayOfInts
	push	eax
	push	[ebp+20]	;@error_2		
	push	[ebp+16]	;@error_1		
	push	[ebp+12]	;@prompt_1		
	push	[ebp+8]		;@inString		

	call	readVal
	loop	top

	pop		ecx
	pop		ebp
	ret		24
getUserData	ENDP


;********************************************************************************************************
;Invokes the getString macro to get the user’s string of digits, converts the digit string to numeric, 
;and validates the user’s input.
;receives: two error prompts, one imput prompt, one DWORD array for storing ints, and one string for reading in keyboard input
;returns: user input values into DWORD array
;preconditions:  push error one, error two, prompt, array, and string in that order
;registers changed: eax, ebx, ecx, edx
;********************************************************************************************************
readVal	PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	push	ecx		;save outer loop
	push	edx
	mov		edi, [ebp+24]

	;[ebp+28] ;@stringLength
	;[ebp+24] ;@arrayOfInts
	;[ebp+20] ;@error_2		
	;[ebp+16] ;@error_1		
	;[ebp+12] ;@prompt_1		
	;[ebp+8]  ;@inString		
	
	getStringMacro [ebp+12], [ebp+8], [ebp+28]	;prompt 1, inString
	mov		eax, [ebp+28]		;string length
	cmp		eax, MAX_IN_SIZE
	jg		notValid
	jmp		getInput

notValid:
	writeStringMacro [ebp+16]			;error 1
	call	crlf
	getStringMacro [ebp+20], [ebp+8], [ebp+28]	;error 2
	mov		eax, [ebp+28]		;string length
	cmp		eax, MAX_IN_SIZE
	jg		notValid

getInput:
	mov		ecx, [ebp+28]	;string length
	mov		eax, 0			;stores number for int conversion
	mov		esi, [ebp+8]
	cld

checkString:
	push	eax			;store number being converted
	mov		eax, 0
	lodsb
	mov		ebx, 0		;clear ebx
	mov		ebx, eax
	pop		eax
	cmp		bl, 48
	jb		notValid
	cmp		bl, 57
	ja		notValid
	mov		edx, 10
	mul		edx
	jc		notValid	;if carry flag is set, number is too big
	sub		bl, 48		;convert digit ASCII to int
	add		eax, ebx
	jc		notValid	;if carry flag is set, number is too big
	loop	checkString		

	mov		[edi], eax	;store value in array

	pop		edx
	pop		ecx			;restore outer loop
	pop		ebx
	pop		eax
	pop		ebp
	ret		24

readVal	ENDP


;********************************************************************************************************
;Calculates the sum of a 10-int DWORD array
;receives: address of an array, address of a DWORD to store sum in
;returns: sum of array in int variable
;preconditions:  push array, then int
;registers changed: eax, ecx
;********************************************************************************************************
calculateSum	PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ecx

	mov		eax, 0
	mov		ecx, 10
	mov		esi, [ebp+8]	;@array

sumLoop:
	add		eax, [esi]
	add		esi, 4
	loop	sumLoop

	mov		edi, [ebp+12]	;@sum
	mov		[edi], eax

	pop		ecx
	pop		eax
	pop		ebp
	ret		8
calculateSum	ENDP



;********************************************************************************************************
;Displays an array of DWORD ints and its DWOR avg as a text string.
;receives: address of an array, address of a DWORD to store sum in
;returns: 
;preconditions:  push sum, array, then output string
;registers changed: 
;********************************************************************************************************
displayData	PROC
	push	ebp
	mov		ebp, esp

	mov		esi, [ebp+12]
	mov		ecx, 10

	;OFFSET output_1	;28
	;OFFSET output_2	;24
	;OFFSET output_3	;20
	;sum				;16
	;OFFSET arrayOfInts	;12
	;OFFSET outString	;8
	writeStringMacro [ebp+28]	;output_1 (array contents)
	call	crlf

displayArray:
	mov		eax, [esi]			;@array
	push	eax
	push	[ebp+8]				;@string
	call	writeVal
	cmp		ecx, 1
	je		noCommaOnLastLoop
	commaSpace
	add		esi, 4
	noCommaOnLastLoop:
	loop	displayArray
	call	crlf

	writeStringMacro [ebp+24]	;output_2 (sum)
	mov		eax, [ebp+16]		;sum
	push	eax
	push	[ebp+8]				;@string
	call	writeVal
	call	crlf

	writeStringMacro [ebp+20]	;output_1 (avg)
	mov		eax, [ebp+16]		;sum
	mov		ebx, 10
	cdq
	div		ebx					;divide sum by 10 to get avg
	push	eax
	push	[ebp+8]				;@string
	call	writeVal
	call	crlf

	pop		ebp
	ret		24

displayData	ENDP

;********************************************************************************************************
;Convert a numeric value to a string of digits, and invoke the displayString macro to produce the output.
;receives: DWORD number to print, address for a location to store the string
;returns: 
;preconditions: push number, then string
;registers changed: eax, ebx, edx
;********************************************************************************************************
writeVal	PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	push	edx

	;[ebp+12] ;number		
	;[ebp+8]  ;@outString		

	mov		eax, [ebp+12]
	mov		edi, [ebp+8]
	add		edi, MAX_OUT_SIZE	;point to end of string
	dec		edi
	std							;move backwards
	mov		ebx, 10				;store divisor
	push	eax
	mov		eax, 0
	stosb						;store a 0 at the end to terminate string
	pop		eax

conversion:
	mov		edx, 0
	div		ebx					;next digit is in edx
	add		edx, 48				;convert to ASCII number
	push	eax
	mov		eax, edx
	stosb						;store digit in string
	pop		eax					;restore eax to the quotient after using it to store the digit
	cmp		eax, 0				;if the quotient is 0, there is no next digit
	jne		conversion			;otherwise, repeat the loop with next left digit

	inc		edi					;edi is one space too far to the left

	writeStringMacro edi		;write it

	pop		edx
	pop		ebx
	pop		eax
	pop		ebp
	ret		8

writeVal	ENDP

END main
