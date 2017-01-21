@ ARM Assembly - lab 2
@ 
@ Roshan Ragel - roshanr@pdn.ac.lk
@ Hasindu Gamaarachchi - hasindu@ce.pdn.ac.lk

	.text 	@ instruction memory
	.global main
main:
	@ stack handling, will discuss later
	@ push (store) lr to the stack
	sub sp, sp, #4
	str lr, [sp, #0]

	@ load values
	@ a,b,i,j in r0,r1,r2,r3 respectively
	mov r0, #10
	mov r1, #5
	mov r2, #7
	mov r3, #-8

	
	@ Write YOUR CODE HERE
	
	@	Sum = 0;
	@	for (i=0;i<10;i++){
	@			for(j=5;j<15;j++){
	@				if(i+j<10) sum+=i*2
	@				else sum+=(i&j);	
	@			}	
	@	} 
	@ Put final sum to r5


	@ ---------------------

	MOV r5,#0
	MOV r3,#5
	MOV r2,#0
	MOV r6,#10
	MOV r7,#15

	
	loop1:
	CMP r2,r6;
	BGE here1;

	MOV r3,#5
	loop2:
	CMP r3,r7;
	BGE here2;

	ADD r8,r2,r3;
	CMP r8,r6;
	BLT here3;
	AND r9,r2,r3;
	ADD r5,r5,r9;
	B ex1;
	here3:
	ADD r5,r5,r2;
	ADD r5,r5,r2;
	ex1:

	ADD r3,r3,#1;
	B loop2;
	here2:

	ADD r2,r2,#1;
	B loop1;
	here1:
	@ ---------------------
	
	
	@ load aguments and print
	ldr r0, =format
	mov r1, r5
	bl printf

	@ stack handling (pop lr from the stack) and return
	ldr lr, [sp, #0]
	add sp, sp, #4
	mov pc, lr

	.data	@ data memory
format: .asciz "The Answer is %d (Expect 300 if correct)\n"

