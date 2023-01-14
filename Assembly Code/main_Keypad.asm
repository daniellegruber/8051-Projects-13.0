$MOD51	; This includes 8051 definitions for the Metalink assembler

;-------------- Define Statements -----------------------


;-------------- Program Start ---------------------------
	ORG		00H
	SJMP	SETUP
		
;-------------- Interrupt Vector Table ------------------		
;--
;--	ISR for External Hardware Interrupt 0 (INT0), (Pin P3.2 or Pin 12)
;		ORG		03H	;External Hardware Interrupt 0 vector table
;		SJMP	ISR_EHI0 ;jump to Interrupt Service Routine (ISR)
;--
;-- ISR for Timer 0 (TF0)
		;ORG		0BH	;Timer 0 interrupt vector table
		;SJMP	ISR_T0	;jump to Interrupt Service Routine (ISR)
;--
;--	ISR for External Hardware Interrupt 1 (INT1), (Pin P3.3 or Pin 13)
;		ORG		13H	;External Hardware Interrupt 1 vector table
;		SJMP	ISR_EHI1 ;jump to Interrupt Service Routine (ISR)
;--
;-- ISR for Timer 1 (TF1)
		;ORG		1BH	;Timer 1 interrupt vector table
		;SJMP	ISR_T1	;jump to Interrupt Service Routine (ISR)
;--
;--	ISR for Serial COM Interrupt (RI and TI)
;		ORG		23H	;Serial COM Interrupt vector table
;		SJMP	ISR_Ser ;jump to Interrupt Service Routine (ISR)

		ORG		30H		;after Interrupt vector table
;-------------- Interrupt Handlers ----------------------
INT_0:
	RETI
TF_0:
	RETI
INT_1:
	RETI
TF_1:
	RETI
SER:
	RETI
	
;-------------- Set Up ----------------------------------	
	
SETUP:
	MOV 	A,		#0FFH	; Loads A with all 1's
	MOV 	Dport,	#0H		; Initializes P2 as output port
			
		
	;Interrupt Enable - IE
	;D7                                                                                     			D0
	;EA				--			ET2			ES			ET1(P3.3)	EX1(edge:SETB TCON.2)	ET0(P3.2)	EX0(edge:SETB TCON.0)
	;Enable All		Not Used	Not 8051	Serial		Timer 1		Ext Int 1				Timer 0		Ext Int 0
	MOV		IE,#10000000B	;Enable Interrupts To Be Turned On
	
	;Timer Control - TCON
	;Timer--------------------------------------------------------------	Interrupts -------------------------------------------------------------------
	;D7                                                                                                                                 D0
	;TCON.7				TCON.6			TCON.5				TCON.4			TCON.3				TCON.2				TCON.1				TCON.0
	;TF1(overflow flag)	TR1(Run Cont)	TF0(overflow flag)	TR0(Run Cont)	IE1(flag edge H->L)	IT1(edge=1,level=0)	IE0(flag edge H->L)	IT0(edge=1,level=0)
	MOV		TCON,#00000101B	;Make external interrupts H->L edge triggered		

;-------------- Main Program ----------------------------

MAIN:	
	ACALL	INIT_LCD	
	ACALL	KEYPAD

;-------------- Include Files ---------------------------

$INCLUDE (LCD.inc)
$INCLUDE (Keypad.inc)

END