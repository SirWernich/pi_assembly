/*
R1 should have the number you want to convert.
Before you call this function, you should make a copy of your Stack Pointer (SP),
then compare the SP to your copy to find out when you've popped everything off
the stack
*/
.global _notostr
_notostr:
	MOV R2, #10		@ set up divisor
	MOV R5, LR		@ save Link Register value
_startconvert:
	EOR R3, R3, R3		@ clear R3
	CMP R1, R2		@ compare number to convert to divisor
	BLHS _modulo		@ go to modulo if R1 >= 10
	ADD R1, R1, #48		@ add 48 to remainder of modulo to get char
	PUSH {R1}		@ push char value to stack
	MOVS R1, R3		@ move the quotient to R1 and set flags
	BNE _startconvert	@ loop if Z = 0
_endconvert:
	MOV LR, R5		@ restore Link Register
	MOV PC, LR		@ return to where you came from originally
