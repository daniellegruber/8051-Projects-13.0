; Define keypad rows and columns
KEY_PORT	EQU		P1
COL1		EQU		P1.3
COL2		EQU		P1.2
COL3		EQU		P1.1
COL4		EQU		P1.0
ROW1		EQU		P1.7
ROW2		EQU		P1.6
ROW3		EQU		P1.5
ROW4		EQU		P1.4
	
; Initialize LCD
;MOV 	A,		#0FFH	; Loads A with all 1's
;MOV 	Dport,	#0H		; Initializes P2 as output port

;ACALL	INIT_LCD				

; Keypad program
KEYPAD:
BACK:	MOV 	KEY_PORT,	#0FFH	; Load P1 with all 1s
		CLR		ROW1				; Make ROW1 low
		JB 		COL1,		NEXT1 	; Check whether COL1 is low and jump to NEXT1 if not low
		MOV		A,			#'1'	; Load A with '1' if column is low (that means key 1 is pressed)
		ACALL	WRT_DATA			; Call WRT_DATA subroutine

NEXT1:	JB		COL2,		NEXT2	; Check whether COL2 is low and so on...
		MOV		A,			#'2'
		ACALL	WRT_DATA
		
NEXT2:	JB		COL3,		NEXT3		
		MOV		A,			#'3'
		ACALL	WRT_DATA
		
NEXT3:	JB		COL4,		NEXT4		
		MOV		A,			#'A'
		ACALL	WRT_DATA
		
NEXT4:	SETB 	ROW1
		CLR 	ROW2
		JB 		COL1,		NEXT5
		MOV 	A,			#'4'
		ACALL	WRT_DATA

NEXT5:	JB		COL2,		NEXT6		
		MOV		A,			#'5'
		ACALL	WRT_DATA

NEXT6:	JB		COL3,		NEXT7		
		MOV		A,			#'6'
		ACALL	WRT_DATA
		
NEXT7:	JB		COL4,		NEXT8		
		MOV		A,			#'B'
		ACALL	WRT_DATA
		
NEXT8:	SETB 	ROW2
		CLR 	ROW3
		JB 		COL1,		NEXT9
		MOV 	A,			#'7'
		ACALL 	WRT_DATA
		
NEXT9:	JB 		COL2,		NEXT10
		MOV 	A,			#'8'
		ACALL 	WRT_DATA
		
NEXT10:	JB 		COL3,		NEXT11
		MOV 	A,			#'9'
		ACALL 	WRT_DATA
		
NEXT11:	JB 		COL4,		NEXT12
		MOV 	A,			#'C'
		ACALL 	WRT_DATA
		
NEXT12:	SETB 	ROW3
		CLR 	ROW4
		JB 		COL1,		NEXT13
		MOV 	A,			#'*'
		ACALL 	WRT_DATA
		
NEXT13:	JB 		COL2,		NEXT14
		MOV 	A,			#'0'
		ACALL 	WRT_DATA

NEXT14:	JB 		COL3,		NEXT15
		MOV 	A,			#'#'
		ACALL 	WRT_DATA

NEXT15:	JB 		COL4,		BACK
		MOV 	A,			#'D'
		ACALL 	WRT_DATA
		LJMP BACK
			
;-------------- Include Files ---------------------------

$INCLUDE (LCD.inc)