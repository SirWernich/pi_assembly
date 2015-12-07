/*
Code for this is taken from "Raspberry Pi Assembly Language" by Bruce Smith

parameters:
R1 -> the number to be divided (the dividend)
R2 -> the number to divide by (divisor)

afterwards:
R1 -> remainder
R2 -> original divisor
R3 -> "int" version of quotient (floor)

NOTE : you must branch with link (BL), otherwise all kinds of crap will happen

*/

.global _modulo
_modulo:
	MOV R4, R2		@ copy divisor to R4
	CMP R4, R1, LSR #1	@ compare the divisor with half of the dividend

_setup:
	MOVLS R4, R4, LSL #1	@ if R4 >= (R1 / 2) then R4 = R4 * 2
	CMP R4, R1, LSR #1	@ compare R4 with half of R1
	BLS _setup		@ branch to start of "_setup" if R4 >= (R1 /2)
	EOR R3, R3, R3		@ clear R3

_divide:
	CMP R1, R4		@ compare R1 to R4
	SUBCS R1, R1, R4	@ if C = 1 then R1 = R1 - R4
	ADC R3, R3, R3		@ R3 = R3 + R3 + carry (if it's set)
	MOV R4, R4, LSR #1	@ R4 = R4 / 2
	CMP R4, R2		@ compare R4 to R2
	BHS _divide		@ if carry set, go to start of "_divide" again
_endmodulo:
	MOV PC, LR		@ return to where branch was called from
