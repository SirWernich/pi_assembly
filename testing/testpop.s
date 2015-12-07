.global _start
_start:
	MOV R1, #34
	MOV R2, #123
	PUSH {R1}
	PUSH {R2}
	POP {R1}
	POP {R2}
_exit:
	MOV R7, #1
	SWI 0

