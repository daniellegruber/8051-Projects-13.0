; LCD.inc
; This file contains LCD subroutines.

;-------------- Define Statements -----------------------
;P1.0-P1.7 are connected to LCD data pins D0-D7 respectively
;P2.0 is connected to RS pin of LCD
;P2.1 is connected to R/W pin of LCD
;P2.2 is connected to E pin of LCD	

RW		EQU		P2.0
RS		EQU		P2.1
E		EQU		P2.2
BUSY	EQU		P1.7		;Use D7 of the LCD to monitor if LCD is busy.
Dport	EQU		P1

;-------------- Subroutine INIT_LCD ---------------------
; NAME: INIT_LCD
; FUNCTION: This subroutine initializes the LCD on power up.
;           This subroutine needs to be run first and prior to using an LCD display.
; EXAMPLES OF USE:

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
		
;-------------- Subroutine READY ------------------------	
; NAME: READY
; FUNCTION: This subroutine checks to see if the LCD is busy, and if the LCD is busy,
;           it waits until the LCD is not busy.
;           This subroutine is embedded in other subroutines.
; EXAMPLES OF USE:

READY:
		SETB	BUSY		;Make P1.7 input pin
		CLR		RS
		SETB	RW
READY1:
		CLR		E
		MOV		B,#50
		ACALL	DELAY_uS	;108.5uS delay
		SETB	E
		JB		P1.7,READY1
		CLR		E
		RET		
		
;-------------- Subroutine COMMAND ----------------------
; NAME: COMMAND
; FUNCTION: Writes commands to the LCD.
; EXAMPLES OF USE:
; 		MOV		A,#85H		;Cursor: line 1, pos. 5
;		ACALL	COMMAND

COMMAND:					;Write Command
		ACALL	READY		;Is LCD ready?
		MOV		P1,A
		CLR		RS
		CLR		RW
		SETB	E
		CLR		E
		RET
		
;-------------- Subroutine DATA_DISPLAY -----------------	
; NAME: DATA_DISPLAY
; FUNCTION: Writes the contents of the acc to the LCD to be displayed.
; EXAMPLES OF USE:
; LCD_1:		
; 		DB		"HELLO",0
;
;		MOV		DPTR,#LCD_1		;Point to the beginning of the word.
;LCD_LINE1:
;		CLR		A				;Clear acc.
;		MOVC	A,@A+DPTR		;Load acc with character being pointed to.
;		JZ		END_LCD_LINE1	;NULL character reached?
;		ACALL	DATA_DISPLAY	;NULL character not reached, print character.
;		INC		DPTR			;Increment pointer to next address.
;		SJMP	LCD_LINE1		;Process next character.
;END_LCD_LINE1:		

DATA_DISPLAY:				;Write Display
		ACALL	READY		;Is LCD ready?
		MOV		P1,A
		SETB	RS
		CLR		RW
		SETB	E
		CLR		E
		RET
		
;-------------- Subroutine DISP_LCD ---------------------
; NAME: DISP_LCD
; FUNTION: Displays RAM addresses 30H through 3FH on the first line of the LCD
;          and displays RAM addresses 40H through 4FH on the second line of the LCD.
; EXAMPLES OF USE:
; 		MOV		34H,#'h'
;		MOV		35H,#'e'
;		MOV		36H,#'l'
;		MOV		37H,#'l'
;		MOV		38H,#'o'
;
;		MOV		44H,#'w'
;		MOV		45H,#'o'
;		MOV		46H,#'r'
;		MOV		47H,#'l'
;		MOV		48H,#'d'
;		
;		ACALL	DISP_LCD		
			
DISP_LCD:
		MOV		R2,#16		;Loop counter
		MOV		A,#80H		;Cursor: line 1, pos. 1
		ACALL	COMMAND
		MOV		R0,#30H		;Data from RAM location
DISP_LCD1:
		MOV		A,@R0		;Move the contents of the address pointed to by @R0 into acc
		ACALL	DATA_DISPLAY
		INC		R0
		DJNZ	R2,DISP_LCD1

		MOV		R2,#16		;Loop counter
		MOV		A,#0C0H		;Cursor: line 2, pos. 1
		ACALL	COMMAND
		MOV		R0,#40H		;Data from RAM location
DISP_LCD2:		
		MOV		A,@R0		;Move the contents of the address pointed to by @R0 into acc
		ACALL	DATA_DISPLAY
		INC		R0
		DJNZ	R2,DISP_LCD2
		RET
		
;-------------- Subroutine MEM_CLR ----------------------	
; NAME: MEM_CLR_LCD
; FUNCTION: Clears RAM locations 30H through 4FH by inserting #20H (space)
; EXAMPLES OF USE:
		
MEM_CLR_LCD:
		MOV		R7,#32
		MOV		R0,#30H
MEM_CLR_LCD1:		
		MOV		@R0,#20H
		INC		R0
		DJNZ	R7,MEM_CLR_LCD1
		RET		
		
;-------------- Subroutine DISP_LCD_Line1 ---------------		
; NAME: DISP_LCD_Line1
; FUNCTION: Displays RAM addresses 30H through 3FH on the first line of the LCD.
; EXAMPLES OF USE:

;-------------- Subroutine DISP_LCD_Line2 ---------------
; NAME: DISP_LCD_Line2
; FUNCTION: Displays RAM addresses 40H through 4FH on the second line of the LCD
; EXAMPLES OF USE:		