@Samurdhi Karunarathne
@e13181

	.text	@ instruction memory

	
	.global main

ROR:
	sub sp,sp,#16
	str r4,[sp,#0]		@backup registers used in main method to the stack
	str r5,[sp,#4]
	str r6,[sp,#8]
	str r7,[sp,#12]

	mov	r4,r0,lsr r2	@(x>>r)
   	rsb	r3,r2,#32
   	orr	r4,r4,r1,lsl r3
    mov	r5,r1,lsr r2

    rsb r2,r2,#64		@(r2=64-r)
    
    rsbs r3,r2,#32		@(x<<(64-r))
    submi r3,r2,#32
    movmi r7,r0,lsl r3
    movpl r7,r7,lsl r2
    orrpl r7,r7,r0,lsr r3
    mov	r6,r0,lsl r2  
    orr r0,r4,r6
    orr r1,r5,r7

   	ldr r4,[sp,#0]		@load backed up values back to the respective registers
   	ldr r5,[sp,#4]
   	ldr r6,[sp,#8]
	ldr r7,[sp,#12]
   	add sp,sp,#16
   	mov pc,lr
ROL:
	sub sp,sp,#16
	str r4,[sp,#0]		@backup registers used in main method to the stack
	str r5,[sp,#4]
	str r6,[sp,#8]
	str r7,[sp,#12]

	mov	r5,r1,lsl r2	@(x<<r)
   	rsb	r3,r2,#32
   	orr	r5,r5,r0,lsr r3
    mov	r4,r0,lsl r2

    rsb r2,r2,#64		@(r2=64-r)
    
    rsbs r3,r2,#32		@(x>>(64-r))
    submi r3,r2,#32
    movmi r6,r1,lsr r3
    movpl r6,r6,lsr r2
    orrpl r6,r6,r1,lsl r3
    mov	r7,r1,lsr r2
    orr r0,r4,r6
   	orr r1,r5,r7

    ldr r4,[sp,#0]		@load backed up values back to the respective registers
    ldr r5,[sp,#4]
    ldr r6,[sp,#8]
    ldr r7,[sp,#12]
    add sp,sp,#16
    mov pc,lr

R:	@first 4 arguments are passed in r0,r1,r2,r3. the last two are passed in the stack(at [sp,#0] and [sp,#4] when entering to the function)
	sub sp,sp,#36
	str r4,[sp,#28]		@backup registers in stack
	str r5,[sp,#32]
	ldr r4,[sp,#36]
	ldr r5,[sp,#40]
	str lr,[sp,#0]
	str r0,[sp,#4]
	str r1,[sp,#8]
	str r2,[sp,#12]
	str r3,[sp,#16]
	str r4,[sp,#20]
	str r5,[sp,#24]

	mov r2,#8			@x=ROR(x,8)
	mov r3,#0
	bl ROR				

	ldr r2,[sp,#12]		@restore y
	ldr r3,[sp,#16]

	adds r0,r0,r2		@x+=y
	adc r1,r1,r3

	eor r0,r0,r4		@x^=k
	eor r1,r1,r5

	str r0,[sp,#4]		@backup new value of x 
	str r1,[sp,#8]

	mov r0,r2			@y=ROL(y,3)
	mov r1,r3
	mov r2,#3
	mov r3,#0
	bl ROL
	mov r2,r0
	mov r3,r1

	ldr lr,[sp,#0]		@load back restored values
	ldr r0,[sp,#4]
	ldr r1,[sp,#8]

	eor r2,r2,r0		@y^=x
	eor r3,r3,r1

	ldr r4,[sp,#28]
	ldr r5,[sp,#32]

	add sp,sp,#36 		@release stack
	mov pc,lr

main:
	sub	sp, sp, #16
	str	lr, [sp, #12]
	
	@printf for keys
	ldr r0,=format3
	bl printf

	@scanf for key1(a)
	ldr	r0, =format0
	mov r1,sp
	bl	scanf	

	ldr r8,[sp,#0]		@a
	ldr r9,[sp,#4]

	@scanf for key2(b)
	ldr	r0, =format0
	mov r1,sp
	bl	scanf	

	ldr r10,[sp,#0]		@b
	ldr r11,[sp,#4]

	@printf for plain text
	ldr r0,=format4
	bl printf

	@scanf for string1(x)
	ldr	r0, =format0
	mov r1,sp
	bl	scanf	

	ldr r4,[sp,#0]		@x
	ldr r5,[sp,#4]

	@scanf for string2(y)
	ldr	r0, =format0
	mov r1,sp
	bl	scanf	

	ldr r6,[sp,#0]		@y
	ldr r7,[sp,#4]

	mov r0,r4			@load arguments to R
	mov r1,r5
	mov r2,r6
	mov r3,r7
	sub sp,sp,#8
	str r10,[sp,#0]
	str r11,[sp,#4]	
	bl R 				@R(x,y,b)
	add sp,sp,#8
	mov r4,r0			@load return values back to the respective registers
	mov r5,r1
	mov r6,r2
	mov r7,r3 

	mov r12,#0	@counter for loop
	loop:
		cmp r12,#31
		beq exit

		sub sp,sp,#8
		str r12,[sp,#0]

		mov r0,#0		@load arguments to R
		str r0,[sp,#4]
		mov r0,r8
		mov r1,r9
		mov r2,r10
		mov r3,r11	
		bl R 			@R(a,b,i)
		add sp,sp,#8
		mov r8,r0		@load return values back to the respective registers
		mov r9,r1
		mov r10,r2
		mov r11,r3

		mov r0,r4		@load arguments to R
		mov r1,r5
		mov r2,r6
		mov r3,r7
		sub sp,sp,#8
		str r10,[sp,#0]
		str r11,[sp,#4]	
		bl R  			@R(x,y,b)
		add sp,sp,#8
		mov r4,r0		@load return values back to the respective registers
		mov r5,r1
		mov r6,r2
		mov r7,r3 

		add r12,r12,#1
		b loop
	exit:

	@printf for cipher text
	ldr r0,=format5
	bl printf

	ldr r0,=format1
	mov r2,r4			@pass lower part to r2
	mov r3,r5			@pass higher part to r3
	bl printf

	ldr r0,=format2
	mov r2,r6			@pass lower part to r2
	mov r3,r7			@pass higher part to r3
	bl printf

	ldr lr,[sp,#12]
	add sp,sp,#16
	mov pc,lr


	.data	@ data memory
format0: .asciz "%llx"
format1: .asciz "%llx "
format2: .asciz "%llx\n"
format3: .asciz "Enter the key:\n"
format4: .asciz "Enter the plain text:\n" 
format5: .asciz "Cipher text is:\n"


