.align 64

.data
	sMask: .byte 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f

.text
	.global fadeShiftAsm

fadeShiftAsm:
	movq %rdx, %rax
	mul %rsi
	movq $8, %rcx
	div %rcx

	# load mask
	movq sMask, %mm3

	movq $0, %rcx
loop_cycle:
	# fade
	movq (%rdi, %rcx, 8), %mm0
	
	# shift
	movq 50(%rdi, %rcx, 8), %mm1

	# div mm0, 4
	psrlq $2, %mm0
	pand %mm3, %mm0

	# mul mm0, 3
	movq %mm0, %mm4
	paddb %mm0, %mm0
	paddb %mm4, %mm0

    # div mm1, 4
	psrlq $2, %mm1
	pand %mm3, %mm1

	# add mm0, mm1
	paddb %mm1, %mm0

	# rewrite
	movq %mm0, (%rdi, %rcx, 8)

	inc %rcx
	cmp %rcx, %rax
	jne loop_cycle

	ret
