.global _start
_start:
	MOV R8, #50		@ load R8 with a number to loop through
_loopstart:
	MOVS R1, R8		@ seed R1 with the current number you're checking
	BLNE _printno		@ print the number currently being checked
	MOVS R1, R8		@ reseed R1 with current number and set flags
	BEQ _exit		@ check if zero flag is set 
_divthree:
	MOV R2, #3		@ seed R2 with divisor
	BL _modulo		@ "branch with link" to "_divide" label
	CMP R1, #0		@ compare remainder with 0
	LDREQ R1, =fizz		@ load R1 with address of "fizz" string if Z = 1
	MOV R2, #4		@ the number of chars to print
	BLEQ _print		@ "branch with link" to "_print" label if Z = 1
	
_divfive:
	MOV R2, #5
	MOV R1, R8
	BL _modulo
	CMP R1, #0
	LDREQ R1, =buzz
	MOV R2, #4
	BLEQ _print

_printnewline:
	CMP R11, #1		@ if R11 = 1, then you need to print a newline
	LDREQ R1, =nwln		@ load R1 with address of "nwln" string if Z = 1
	MOVEQ R2, #1		@ load R2 with 1 (one char to print) if Z = 1
	BLEQ _print		@ go to "_print" label if Z = 1
	EOR R11, R11, R11	@ clear R11
	SUB R8, R8, #1		@ subtract 1 from R8 and set flags
	BAL _loopstart

@ load R1 with address and R2 with num of chars to print before printing
_print:
	MOV R0, #1		@ print to screen
	MOV R7, #4		@ syscall 4 - write
	SWI 0			@ software interrupt
	MOV R11, #1		@ set R11 = 1 to say printing has been done, then if you need to print newline, check R11 = 1
	MOV PC, LR		@ return to where branch was called

_printno:
	MOV R1, R8
	PUSH {LR}
	MOV R9, SP
	BL _notostr
_printstrno:
	CMP R9, SP
	POPEQ {PC}
	POP {R3}
	LDR R1, =numb
	STR R3, [R1]
	MOV R2, #1
	MOV R5, LR
	BL _print
	MOV LR, R5
	BAL _printstrno

_exit:
	MOV R7, #1		@ syscall - exit
	SWI #0			@ return to OS
.data
	fizz: .ascii "fizz"
	buzz: .ascii "buzz"
	nwln: .ascii "\n"
	numb: .ascii " "
