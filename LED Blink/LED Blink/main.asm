$MOD51	; This includes 8051 definitions for the Metalink assembler

LED 	BIT 	P1.0
;--------------------------------------------
ORG 	00H
MOV		P1,	#00H			; Configure Port 1 as output port
;--------------------------------------------
MAIN:
	SETB 	LED
	ACALL 	DELAY
	CLR		LED
	ACALL	DELAY
	SJMP	MAIN

;-------------------------------------------

DELAY:						; Define DELAY subroutine
	MOV		R4,		#6		; Load R4 with #6

DL1:						; Define DL1 process
	MOV		R3,		#255	; Load R3 with #255
	DJNZ	R3,		$		; Decrement R3 until 0
	
	DJNZ	R4, 	DL1		; Decrement R4 until 0, if not 0 repeat DL1

	RET						; Return to location of call in program
;--------------------------------------------

END