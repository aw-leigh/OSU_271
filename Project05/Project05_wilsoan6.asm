TITLE Sorting Random Integers    (Project05.asm)

; Author: Andrew Wilson
; Last Modified: Feb 10, 2019
; OSU email address: wilsoan6@oregonstate.edu
; Course number/section: 271-400
; Project Number: #5                Due Date: March 3, 2019
; Description: This program generates random numbers in the range [100 .. 999],
;			   displays the original list, sorts the list, and calculates the
;			   median value. Finally, it displays the list sorted in descending order.

INCLUDE Irvine32.inc

LO = 100	;lowest int value
HI = 999	;highest int value
MIN = 10	;min number of ints
MAX = 200	;max number of ints

.data
numberOfInts	DWORD	?			;user specified number of ints to show
arrayOfInts		DWORD	MAX	DUP(?)	;array of ints.
intro_1			BYTE	"Welcome to Sorting Random Integers     by Andrew Wilson ", 0
intro_2			BYTE	"This program generates random numbers in the range [100 .. 999],", 0
intro_3			BYTE	"displays the original list, sorts the list, and calculates the", 0
intro_4			BYTE	"median value. Finally, it displays the list sorted in descending order.", 0
title_1			BYTE	"The unsorted random numbers:", 0
title_2			BYTE	"The sorted list:", 0
title_3			BYTE	"The median is: ", 0
ec_1			BYTE	"**EC: Aligns the output columns", 0
prompt_1		BYTE	"How many numbers should be generated? [10 .. 200]: ", 0
error_1			BYTE	"Please enter a number between 10 and 200: ",0

.code
main PROC

	call	randomize

	push	OFFSET intro_1
	push	OFFSET intro_2
	push	OFFSET intro_3
	push	OFFSET intro_4
	call	introduction
	

	push	OFFSET error_1
	push	OFFSET prompt_1
	push	OFFSET numberOfInts		
	call	getUserData

	push	OFFSET arrayOfInts
	push	numberOfInts
	call	fillArray

	push	OFFSET title_1	
	push	OFFSET arrayOfInts
	push	numberOfInts
	call	displayList

	push	OFFSET arrayOfInts
	push	numberOfInts
	call	sortList

	push	OFFSET title_3	
	push	OFFSET arrayOfInts
	push	numberOfInts
	call	displayMedian

	push	OFFSET title_2	
	push	OFFSET arrayOfInts
	push	numberOfInts
	call	displayList

	exit	; exit to operating system
main ENDP

;********************************************************************************************************
;Procedure to introduce the program.
;receives: none
;returns: none
;preconditions:  needs strings called intro_1, intro_2, intro_3, intro_4 and ec_1
;registers changed: edx
;********************************************************************************************************
introduction	PROC
	push	ebp
	mov		ebp, esp

	mov		edx, [ebp+20]	;@intro_1
	call	WriteString
	call	crlf
	mov		edx, [ebp+16]	;@intro_2
	call	WriteString
	call	crlf
	mov		edx, [ebp+12]	;@intro_3
	call	WriteString
	call	crlf
	mov		edx, [ebp+8]	;@intro_4
	call	WriteString
	call	crlf
	call	crlf

	pop		ebp
	ret		16
introduction	ENDP

;********************************************************************************************************
;Procedure to get value for numberOfInts from the user.
;receives: numberOfInts
;returns: user input values for variable numberOfInts
;preconditions:  push numberOfInts before calling
;registers changed: eax, ebx, edx
;********************************************************************************************************
getUserData	PROC
	push	ebp
	mov		ebp, esp
	mov		edx, [ebp+12]	;prompt_1
	call	WriteString
	call	ReadInt

TryAgain:					;validates that input is between MIN-MAX
	cmp		eax, MIN
	jb		invalidInput
	cmp		eax, MAX
	ja		invalidInput
	jmp		AllIsWell

InvalidInput:
	mov		edx, [ebp+16]	;error_1
	call	WriteString
	call	ReadInt
	jmp		TryAgain

AllIsWell:
	mov		ebx, [ebp+8]
	mov		[ebx], eax	

	call	Crlf
	pop		ebp
	ret		12
getUserData	ENDP

;********************************************************************************************************
;Procedure to fill array with random numbers
;receives: array of dwords to store ints, number of ints to generate
;returns: random ints into array
;preconditions: push array address, then number of ints
;registers changed: edx
;********************************************************************************************************
fillArray	PROC
	push	ebp
	mov		ebp, esp
	mov		edi, [ebp+12]	;@arrayOfInts
	mov		ecx, [ebp+8]	;loop counter

again:
	mov		eax, HI-LO
	inc		eax
	call	randomrange
	add		eax, LO			;eax now contains random number between HI and LO
	mov		[edi], eax		;store it in the array
	add		edi, 4			;move to the next element
	loop	again

	pop		ebp
	ret		8
fillArray	ENDP

;********************************************************************************************************
;Bubble sorts array of ints high to low
;receives: array of dwords to store ints, length of array
;returns: sorted ints into array
;preconditions: push array address, then number of ints
;registers changed: eax, ebx, ecx, edx
;********************************************************************************************************
sortList	PROC
	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp+8]	;loop counter
	mov		ebx, -1			;ebx tracks number of times inner loop has occurred
							;bubble sort sorts 1 element per loop, so we need to loop element number of times
							;Starts at -1 because it is incremented immediately in loop

outer:
	mov		esi, [ebp+12]	;@arrayOfInts
	push	ecx				;push outer loop counter
	inc		ebx				;ebx tracks number of times inner loop has occurred
	mov		ecx, [ebp+8]	;loop the length of the array...
	sub		ecx, ebx		;...minus the number of sorted elements
	
	dec		ecx				;;;;
	cmp		ebx, 0			;this block decrements ecx by 1 on the first time thought the loop
	je		inner			;to prevent out-of-bounds access if the array is MAX size
	inc		ecx				;;;;


inner:
	mov		eax, [esi]		;move contents of left array element into eax
	cmp		eax, [esi+4]	;compare to contents of right array element
	jb		swap
	jmp		noSwap
swap:		
	push	esi				;@left element
	add		esi, 4
	push	esi				;@right element
	sub		esi, 4
	call	exchange
noSwap:
	add		esi, 4
	loop	inner
finished:
	pop		ecx				;restore outer loop counter
	loop	outer

	pop		ebp
	ret		8
sortList	ENDP

;********************************************************************************************************
;Swaps two ints
;receives: two ints by reference
;returns: swapped ints
;preconditions: push two DWORD ints
;registers changed: eax, edx
;********************************************************************************************************
exchange	PROC
	push	ebp
	mov		ebp, esp
	mov		edi, [ebp+12]	;@left element
	mov		eax, [edi]		;left element
	mov		edi, [ebp+8]	;@right element
	mov		edx, [edi]		;right element

	mov		[edi], eax
	mov		edi, [ebp+12]	;@left element
	mov		[edi], edx

	pop		ebp
	ret		8

exchange	ENDP


;********************************************************************************************************
;Procedure to calculate and display median
;receives: array of dword ints, number of ints, title to display
;returns: prints median to console
;preconditions: push title, array address, then number of ints
;registers changed: eax, ebx, edx
;********************************************************************************************************
displayMedian	PROC
	push	ebp
	mov		ebp, esp
	mov		edx, [ebp+16]	;@title
	call	WriteString

	mov		edi, [ebp+12]	;@arrayOfInts
	mov		eax, [ebp+8]	;number of ints

	mov		ebx, 2
	cdq
	div		ebx				;divide count by 2 (ignoring remainder) for index of middle element
	mov		ebx, 4
	mul		ebx				;multiply by 4 to get offset from array

	test	ax, 1			;test if count is even or odd (LSB is 1 or 0)
	jz		isEven
	jnz		isOdd

isOdd:
	mov		edx, [edi+eax]
	mov		eax, edx
	call	WriteDec
	jmp		theEnd
isEven:
	mov		edx, [edi+eax]
	sub		eax, 4
	add		edx, [edi+eax]	;sum the two middle numbers
	mov		eax, edx
	mov		ebx, 2
	cdq
	div		ebx				;divide by two
	call	WriteDec
	test	dx, 1			;if there is a remainder, display '.5'
	jz		theEnd			
	mov		eax, 46			;46 is ASCII '.'
	call	WriteChar
	mov		eax, 53			;53 is ASCII '5'
	call	WriteChar

theEnd:
	call	crlf
	call	crlf

	pop		ebp
	ret		12
displayMedian	ENDP

;********************************************************************************************************
;Procedure to display an array of DWORD integers
;receives: address of title of array to display, address of array of dwords to store ints, number of ints to generate
;returns: -
;preconditions: push title, array address, then number of ints
;registers changed: eax, ecx, edx
;********************************************************************************************************
displayList	PROC
	push	ebp
	mov		ebp, esp
	mov		edx, [ebp+16]	;@title
	call	WriteString
	call	crlf
	mov		esi, [ebp+12]	;@arrayOfInts
	mov		ecx, [ebp+8]	;loop counter
	mov		edx, 0			;use edx as a counter to space lines

again:
	mov		eax,[esi]		;put array value in eax
	call	WriteDec
	mov		eax, 9			;9 is ASCII tab, used to space columns
	call	WriteChar
	inc		edx
	cmp		edx, 10			
	jne		noNewLine		;if 10 characters have been written, newline, then set edx back to 0
	call	crlf
	mov		edx, 0

noNewLine:
	add		esi, 4			;move to the next element
	loop	again

	call	crlf
	call	crlf

	pop		ebp
	ret		12
displayList	ENDP

END main
