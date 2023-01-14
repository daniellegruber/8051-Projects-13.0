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
		MOV		P1,#00H	;Make P1 an output port
		MOV		P2,#00H	;Make P2 an output port
LCD_1:		
		DB		"HELLO",0
LCD_2:		
		DB		"WORLD",0
			
		
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
		
;         ---- First Way to Write to LCD ----		
		
		MOV		A,#85H			;Cursor: line 1, pos. 5
		ACALL	COMMAND			;Issue command to LCD.
		
		MOV		DPTR,#LCD_1		;Point to the beginning of the word.
LCD_LINE1:
		CLR		A				;Clear acc.
		MOVC	A,@A+DPTR		;Load acc with character being pointed to.
		JZ		END_LCD_LINE1	;NULL character reached?
		ACALL	DATA_DISPLAY	;NULL character not reached, print character.
		INC		DPTR			;Increment pointer to next address.
		SJMP	LCD_LINE1		;Process next character.
END_LCD_LINE1:	

		MOV		A,#0C5H			;Cusor: line 2, pos. 5
		ACALL	COMMAND			;Issue command to LCD.
		
		MOV		DPTR,#LCD_2		;Point to the beginning of next word.
LCD_LINE2:		
		CLR		A				;Clear acc.
		MOVC	A,@A+DPTR		;Load acc with character being pointed to.
		JZ		END_LCD_LINE2	;NULL character reached?
		ACALL	DATA_DISPLAY	;NULL character not reached, print character.
		INC		DPTR			;Increment pointer to next address.
		SJMP	LCD_LINE2	;Process next character.
END_LCD_LINE2:					;All characters processed.

		MOV		B,#1
		ACALL	DELAY_s		;With B=1, the delay is 1 second

;         ---- Second Way to Write to LCD ----		

		ACALL	MEM_CLR_LCD	;clear RAM memory associated with LCD
		
		MOV		34H,#'h'
		MOV		35H,#'e'
		MOV		36H,#'l'
		MOV		37H,#'l'
		MOV		38H,#'o'

		MOV		44H,#'w'
		MOV		45H,#'o'
		MOV		46H,#'r'
		MOV		47H,#'l'
		MOV		48H,#'d'
		
		ACALL	DISP_LCD

HERE:	SJMP	HERE		;Stay here

;-------------- Include Files ---------------------------

$INCLUDE (LCD.inc)
$INCLUDE (Delays.inc)

END