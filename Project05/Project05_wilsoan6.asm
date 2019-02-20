TITLE Sorting Random Integers    (Project05.asm)

; Author: Andrew Wilson
; Last Modified: Feb 10, 2019
; OSU email address: wilsoan6@oregonstate.edu
; Course number/section: 271-400
; Project Number: #5                Due Date: March 3, 2019
; Description: This program displays composite numbers.
;			   It will prompt the user to enter the number of composites to be displayed, validate the input,
;			   then  calculate and display all of the composite numbers up to and including the nth composite.
;			   It will then display a parting message to the user by name.

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data
MAXCOMPOSITE =  400			;maximum value for user input
numberToShow	DWORD	?	;user specified number of composite numbers to show
numberToTest	DWORD	?	;current number to test if composite
counter			DWORD	0	;used to space columns
primeNumbers	DWORD	2, 3, 5, 7, 11, 13, 17, 19, 23, 0; 23 is enough because 23^2 > 495 (see sieve of eratosthenes)
intro_1			BYTE	"Welcome to Composite Numbers by Andrew Wilson ", 0
ec_1			BYTE	"**EC: Aligns the output columns", 0
prompt_1		BYTE	"Enter the number of composite numbers you would like to see.", 0
prompt_2		BYTE	"I'll accept orders for up to 400 composites: ", 0
error_1			BYTE	"Please enter a number between 1 and 400: ",0
goodBye			BYTE	"Thank you for playing Composite Numbers!", 0

.code
main PROC

	call	introduction
	call	getUserData
	call	showComposites
	call	farewell

	exit	; exit to operating system
main ENDP

;Procedure to introduce the program.
;receives: none
;returns: none
;preconditions:  needs strings called intro_1, prompt_1, prompt_2, and ec_1
;registers changed: edx
introduction	PROC

	mov		edx, OFFSET	intro_1
	call	WriteString
	call	crlf
	call	crlf
	mov		edx, OFFSET	prompt_1
	call	WriteString
	call	crlf
	mov		edx, OFFSET	ec_1
	call	WriteString
	call	crlf
	call	crlf
	mov		edx, OFFSET	prompt_2
	call	WriteString

	ret
introduction	ENDP


;Procedure to get value for numberToShow from the user.
;receives: none
;returns: user input values for global variable numberToShow
;preconditions:  needs to store int in "numberToShow"
;registers changed: eax, edx
getUserData	PROC
	call	ReadInt
	mov		numberToShow, eax	
	call	validate

	ret
getUserData	ENDP


;Procedure to validate that numberToShow is between 1-400
;receives: none
;returns: validated value for global variable numberToShow
;preconditions:  none
;registers changed: eax,edx
validate	PROC

TryAgain:
	mov		eax, numberToShow
	cmp		eax, 1
	jb		invalidInput
	cmp		eax, MAXCOMPOSITE
	ja		invalidInput
	jmp		AllIsWell
InvalidInput:
	mov		edx, OFFSET	error_1
	call	WriteString
	call	ReadInt
	mov		numberToShow, eax
	jmp		TryAgain

AllIsWell:
	ret
validate	ENDP

;Procedure to display composite numbers between 1-400
;receives: none
;returns: none
;preconditions:  numberToShow is the number of composites to output 
;registers changed: eax, ecx
showComposites	PROC
	mov		ecx, numberToShow
	mov		numberToTest, 4		;start at the first composite number, 4

L1:
	call	isComposite
	inc		numberToTest
	loop	L1
	ret
showComposites	ENDP

;Procedure to determine whether a number is composite or not
;receives: none
;returns: assumes it will be used in a loop, so increments ecx if result is prime
;preconditions:  numberToTest is the initial number to test (2 or greater),
;				 needs a global array of prime numbers called "primeNumbers" that starts at 2 and ends with 0.
;registers changed: eax, ebx, ecx, edx, esi
isComposite	PROC
	mov		eax, numberToTest			
	mov		esi, OFFSET primeNumbers	;point to the beginning of the primes array

tryAgain:
	mov		edx, 0
	mov		eax, numberToTest
	mov		ebx, [esi]					;move the first prime number into ebx
	cmp		eax, ebx					;if the number being compared is equal to the current prime divisor,
	je		prime						;then it's prime
	cdq								
	div		ebx
	cmp		edx, 0						;if remainder = 0, it's composite
	jz		foundComposite
	add		esi, 4
	mov		ebx, [esi]					;move the next prime number into ebx
	cmp		ebx, 0						;check if it's 0. If so, we've reached the end of the list and the number is prime
	je		prime						
	jmp		tryAgain

prime:
	inc		ecx							;if number is prime, add 1 to ecx to counteract the dec ecx in outer loop
	jmp		done						;so that the prime number doesn't count against the number of composites to show

foundComposite:
	mov		eax, numberToTest			;print the number
	call	WriteDec
	mov		eax, 9						;9 is ASCII tab, used to space columns
	call	WriteChar
	
	inc		counter
	mov		eax, counter				;check if counter is divisible by 10
	mov		ebx, 10
	cdq
	div		ebx
	cmp		edx, 0
	je		DivisibleBy10				;if it is, newline
	jmp		done

DivisibleBy10:
	call	crlf

done:
	ret
isComposite	ENDP


;Procedure to display farewell message to user.
;receives: none
;returns: none
;preconditions:  needs string "goodBye"
;registers changed: edx
farewell	PROC
	call	crlf
	mov		edx, OFFSET	goodBye
	call	WriteString
	call	crlf

	ret
farewell	ENDP


END main
