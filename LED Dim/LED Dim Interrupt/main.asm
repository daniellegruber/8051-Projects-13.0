$MOD51								; 8051 definitions for Metalink assembler

LED			EQU		P1.0			; LED connected to P1.0
FLAG		EQU		P3.0			; Flag to remain in loop while timer counts
LOW_TH		EQU		0FCH			; Define timer value for low part of pulse
LOW_TL		EQU		66H				
HIGH_TH		EQU		0FEH			; Define timer value for high part of pulse
HIGH_TL		EQU		33H

ORG		0000H
SJMP	MAIN

ORG		001BH						; Timer 1 interrupt vector table
SJMP	ISR_T1						; Jump to ISR

ORG		0030H						; After vector table
MAIN:	MOV		TMOD,	#10H		; Timer 1, mode 1
		MOV		IE,		#88H		; Enable Timer 1 interrupt

LOW_PULSE:	SETB	FLAG
			CLR		LED
			MOV		TL1,	#LOW_TL		; Low byte
			MOV 	TH1,	#LOW_TH		; High byte
			SETB	TR1					; Start Timer 1
			JB		FLAG,	$			; Loop while waiting for an interrupt
			
HIGH_PULSE:	SETB	FLAG
			SETB	LED
			MOV		TL1,	#HIGH_TL	; Low byte
			MOV 	TH1,	#HIGH_TH	; High byte
			SETB	TR1					; Start Timer 1
			JB		FLAG,	$			; Loop while waiting for an interrupt
			SJMP	LOW_PULSE
										
ISR_T1:		CLR	FLAG
			CLR		TR1				; Stop Timer 1
			;CPL	LED				; Complement LED pin to toggle high, low
			RETI					; Return from interrupt to where program came from
		
		
END