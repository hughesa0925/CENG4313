IOCON_P0_13		EQU 0x4002C034  ; P1[13] IOCON_P1_13 R/W 0x1B0 0x4002C034
IOCON_P1_18		EQU 0x4002C0C8  ; P1[18] IOCON_P1_18 R/W 0x030 0x4002 C0C8 D (tables 83, 84)

; This is essentially Table 94 from UM10562
LPC4088QSB_P0	EQU 0x20098000
LPC4088QSB_P1	EQU 0x20098020
LPC4088QSB_P2	EQU 0x20098040
LPC4088QSB_P3	EQU 0x20098060
LPC4088QSB_P4	EQU 0x20098080
LPC4088QSB_P5	EQU 0x200980A0
DIR_REG_OFFSET	EQU 0x00
MSK_REG_OFFSET	EQU 0x10
PIN_REG_OFFSET	EQU 0x14
SET_REG_OFFSET	EQU 0x18
CLR_REG_OFFSET	EQU 0x1C
; End Table 94

bit13 			EQU (1 << 13) ; 0x00002000
bit18 			EQU (1 << 18) ; 0x00040000


	AREA my_asm, CODE, READONLY
	ENTRY

	EXPORT		__main
__main

	; setup LED#1 on port1[18]
	; setup the, IOCON, I/O configuration - default is 0x30, setup to 0x00
	; setup for GPIO and inactive and no hysteresis
	LDR		R1, =IOCON_P0_13    ; Pg 126 
	LDR		R2, =0x00000000
	STR		R2,[R1,#0x00]
	
	LDR     R1,=LPC4088QSB_P0      		; pointer to base reg of port1 - Pg 146
	LDR     R3,=bit13      				; set LED 2 port pin to output - pin 13
	STR     R3,[R1,#DIR_REG_OFFSET]    	; set DIRECTION bits

	LDR     R1,=LPC4088QSB_P0      		; pointer to base reg of port1 
	LDR     R3,=0x00000000      		; MSK register setting
	STR     R3,[R1,#MSK_REG_OFFSET]   	; set MASK bits 

	;# LED is NEGATIVE logic, 
	;# SET turns it OFF
	;# CLR turns it ON
	LDR     R1,=LPC4088QSB_P0      		; pointer to base reg of port1
	LDR     R3,=bit13      				; SET register setting
	STR     R3,[R1,#SET_REG_OFFSET]   	; set SET bits - This turns OFF the LED

	bl delay

	LDR     R1,=LPC4088QSB_P0      		; pointer to base reg of port1
	LDR     R3,=bit13      				; CLR register setting
	STR     R3,[R1,#CLR_REG_OFFSET]   	; set CLEAR bits - This turns ON the LED
		
	
loop

	bl delay
	STR     R3,[R1,#CLR_REG_OFFSET]   	; set CLEAR bits - This turns ON the LED
	bl delay
	STR     R3,[R1,#SET_REG_OFFSET]   	; set CLEAR bits - This turns OFF the LED
	B       loop                ; branch to loop (endless loop!)



    
; ------------------------------------------
; Delay subroutine 
delay
	PUSH {R0,LR}
	MOVS  r0, #0x1000000  	;1 cycle
B1 
	SUBS  r0, r0, #1 		;1 cycle
	BNE   B1          		;2 if taken, 1 otherwise
	POP	{R0,PC}
; end delay subroutine
; ------------------------------------------

  ALIGN
  END
