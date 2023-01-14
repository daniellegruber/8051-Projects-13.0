
;-------------- Delay in seconds ------------------------
;(255*255*7*B*2.17uS)+2.17uS+2.17uS = 0.987734 seconds
; B=1 -> 0.987734 seconds
; B=2 -> 1.975468 seconds

DELAY_s:
DELAY_s4:
	MOV R3,#7
DELAY_s3:
	MOV R2,#255
DELAY_s2:	
	MOV R1,#255
DELAY_s1:
	DJNZ R1,DELAY_s1
	DJNZ R2,DELAY_s2
	DJNZ R3,DELAY_s3
	DJNZ B,DELAY_s4
	RET

;-------------- Delay in milli-seconds ------------------
; (5*92*B*2.17uS)+2.17uS+2.17uS = 1.000434mS if register B is 1
; B=1 -> 1.000434mS
; B=2 -> 2.000740mS

;Max delay is B=FF (255) for 255mS

DELAY_mS:
DELAY_mS3:
	MOV R3,#5				;2 Cycles
DELAY_mS2:
	MOV R2,#92				;2 Cycles
DELAY_mS1:	
	DJNZ	R2,DELAY_mS1	;2 Cycles
	DJNZ	R3,DELAY_mS2	;2 Cycles
	DJNZ	B,DELAY_mS3		;2 Cycles
	RET
	
; uS delay is accomplished with NOP = 1.085uS
;-------------- Delay in micro-seconds ------------------
; (B*2.17uS)
; B=1 -> 2.17uS
; B=2 -> 4.34uS
; B=255 -> 553.39uS

DELAY_uS:
	DJNZ	B,DELAY_uS	;2 Cycles
	RET
