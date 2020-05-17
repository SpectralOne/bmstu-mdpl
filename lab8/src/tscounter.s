.align 64

.text
	.global tsCount
tsCount:
	pushq %rbx

	xor %rax, %rax
	cpuid # force stop op
	rdtsc # time-stamp counter

	popq %rbx
	ret # %rdx:%rax
