$MOD51	; This includes 8051 definitions for the Metalink assembler

;-------------- Define Statements -----------------------
;P2.0-P2.7 are connected to LCD data poins D0-D7
;P0.0 is connected to RS pin of LCD
;P0.1 is connected to R/W pin of LCD
;P0.2 is connected to E pin of LCD	

RS			EQU		P0.0
RW			EQU		P0.1
E			EQU		P0.2
DATA_PORT	EQU		P2
BF			EQU		P2.7

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
		MOV		DATA_PORT,#00H	;Make P2 an output port
		MOV		P0,#00H	;Make P0 an output port
LCD_1:	
		;DB		"HELLO", 0
		DB	'HELLO', 0
LCD_2:	
		;DB		"WORLD", 0
		DB	'WORLD', 0
			
		
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
		
		MOV		A,#85H		;Cursor: line 1, pos. 5
		ACALL	COMMAND
		ACALL	DELAY
		MOV		DPTR,#LCD_1	;Load ROM Pointer
WORD1:		
		CLR		A
		MOVC	A,@A+DPTR
		JZ		NEXTWORD
		ACALL	DATA_DISPLAY
		ACALL	DELAY
		INC		DPTR
		SJMP	WORD1		
NEXTWORD:		
		MOV		A,#0C5H		;Cusor: line 2, pos. 5
		ACALL	COMMAND
		ACALL	DELAY
		MOV		DPTR,#LCD_2
WORD2:		
		CLR		A
		MOVC	A,@A+DPTR
		JZ		HERE
		ACALL	DATA_DISPLAY
		ACALL	DELAY
		INC		DPTR
		SJMP	WORD2

HERE:	SJMP	HERE		;Stay here

;-------------- LCD routines ---------------------------

INIT_LCD:
		MOV		B,#40
		ACALL	DELAY_mS	;40mS Delay
		MOV		A,#38H		;Init LCD 2 Lines, 5x8 matrix
		ACALL	COMMAND
		MOV		A,#0EH		;LCD on, cursor on
		ACALL	COMMAND
		MOV		A,#01H		;clear LCD command
		ACALL	COMMAND
		MOV		A,#06H		;shift cursor right
		ACALL	COMMAND
		RET
		
READY:
		SETB	BF		;Make P2.7 input pin
		CLR		RS
		SETB	RW
		;SETB	E
BACK:
		;CLR		E
		;SETB	E
		;JB		BF, BACK
		;NOP
		;CLR	E
		ACALL	DELAY
		RET		
		
COMMAND:					;Write Command
		ACALL	READY		;Is LCD ready?
		MOV		DATA_PORT, A
		CLR		RS
		CLR		RW
		SETB	E
		NOP
		CLR		E
		RET

DATA_DISPLAY:				;Write Display
		ACALL	READY		;Is LCD ready?
		MOV		DATA_PORT, A
		SETB	RS
		CLR		RW
		SETB	E
		NOP					;1.085uS Delay ... was originally 553.35uS
		CLR		E
		RET
		
;-------------- Delay routines ---------------------------

;-------------- Delay in seconds ------------------------
;(255*255*7*B*2.17uS)+2.17uS+2.17uS = 0.987734 seconds
; B=1 -> 0.987734 seconds
; B=2 -> 1.975468 seconds

DELAY_s:
S4:
	MOV R3,#7
S3:
	MOV R2,#255
S2:	
	MOV R1,#255
S1:
	DJNZ R1, S1
	DJNZ R2, S2
	DJNZ R3, S3
	DJNZ B, S4
	RET

;-------------- Delay in milli-seconds ------------------
; (5*92*B*2.17uS)+2.17uS+2.17uS = 1.000434mS if register B is 1
; B=1 -> 1.000434mS
; B=2 -> 2.000740mS

;Max delay is B=FF (255) for 255mS

DELAY_mS:
mS3:
	MOV R3,#5		;2 Cycles
mS2:
	MOV R2,#92		;2 Cycles
mS1:	
	DJNZ	R2,mS1	;2 Cycles
	DJNZ	R3,mS2	;2 Cycles
	DJNZ	B,mS3	;2 Cycles
	RET
	
; uS delay is accomplished with NOP = 1.085uS
;-------------- Delay in micro-seconds ------------------
; (B*2.17uS)
; B=1 -> 2.17uS
; B=2 -> 4.34uS
; B=255 -> 553.39uS

DELAY_uS:
uS1:
	DJNZ	B,uS1	;2 Cycles
	RET

; DELAY subroutine
DELAY: 		MOV 	R3, 	#255	; Load R3 with 255
L2: 		MOV 	R4,	#2	; Load R4 with 2
L1: 		DJNZ 	R4, 	L1	; Decrement R4, if not zero repeat L1
		DJNZ 	R3, 	L2	; Decrement R3, if not zero repeat L1
		RET

END