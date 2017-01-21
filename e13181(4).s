@ ARM Assembly Example
@	a function to find string length
@	Call it from main
@	
@ Roshan Ragel - roshanr@pdn.ac.lk
@ Hasindu Gamaarachchi - hasindu@pdn.ac.lk

	.text	@ instruction memory

	
	.global main
main:
	
	@ push (store) lr to the stack, allocate space for 400 chars (scanf)
	
	sub	sp, sp, #404
	str	lr, [sp, #400]
	
	@printf for number
	ldr	r0, =format0
	bl	printf
	
	@scanf for number
	ldr	r0, =format6
	mov	r1, sp
	bl	scanf	@scanf("%d",sp)


	@check for Invalid input
	ldr r4,[sp,#0]
	cmp r4,#0
	bge ok
	ldr	r0, =format3
	bl	printf
	ldr lr,[sp,#400]
	add sp,sp,#404
	mov pc,lr

	ok:

	mov r5,#0 @counter

	loop:
	cmp r5,r4
	bge exit
	bl getchar
	@print for string
	ldr	r0, =format1
	mov r1,r5
	bl	printf


	@scanf for string
	ldr r0,=format8
	mov	r1, sp
	bl scanf


	mov r6,sp

	mov r8,#0
	loop1:
	ldrb r7,[r6,#0]
	cmp r7,#0 
	beq end
	add r6,r6,#1
	add r8,r8,#1
	b loop1
	end:

	sub r6,r6,r8


	add sp,sp,#200
	mov r9,sp

	add r9,r9,r8
	mov r11,#0
	strb r11,[r9,#0]
	sub r8,r8,#1
	sub r9,r9,#1

	mov r10,#0
	loop2:
	ldrb r7,[r6,#0]
	cmp r10,r8
	bgt end1
	strb r7,[r9,#0] 
	add r6,r6,#1
	add r10,r10,#1
	sub r9,r9,#1
	b loop2
	end1:

	add r9,r9,#1
	@print the reversed string
	ldr r0,=format4
	mov r1,r5
	mov r2,r9
	bl printf

	sub sp,sp,#200
	add r5,r5,#1
	b loop

	exit:

	ldr lr,[sp,#400]
	add sp,sp,#404
	mov pc,lr


	.data	@ data memory
format0: .asciz "Enter the number of strings :\n"
format1: .asciz "Enter the input string %d :\n"
format3: .asciz "Invalid number\n"
format4: .asciz "Output string %d is :\n%s\n"
format6: .asciz "%d"
format7: .asciz "%s"
format8: .asciz "%99[^\n]"


