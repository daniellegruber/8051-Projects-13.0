$MOD51								; 8051 definitions for Metalink assembler

LED			EQU		P1.0			; LED connected to P1.0
LOW_TH		EQU		0FCH			; Define timer value for low part of pulse
LOW_TL		EQU		66H				
HIGH_TH		EQU		0FEH			; Define timer value for high part of pulse
HIGH_TL		EQU		33H				

ORG		0030H

MOV	TMOD,	#10H					; Timer 1, mode 1

MAIN:	

LOW_PULSE:	CLR	LED
			MOV	TL1,	#LOW_TL		; Low byte
			MOV TH1,	#LOW_TH		; High byte
			ACALL		TIMER		; Call TIMER subroutine
			
HIGH_PULSE:	SETB	LED
			MOV	TL1,	#HIGH_TL	; Low byte
			MOV TH1,	#HIGH_TH	; High byte
			ACALL		TIMER		; Call TIMER subroutine
			SJMP 		MAIN
										
TIMER:		SETB	TR1
			JNB		TF1,	TIMER	; Stay until timer rolls over
			CLR		TR1				; Stop Timer 1
			CLR		TF1				; Clear Timer 1 flag
			RET						; Reload timer since Mode 1 isn't auto-reloaded
		
		
END