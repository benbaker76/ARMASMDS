	.arm
	.align
	.global initSystem
	.global main

initSystem:
	bx lr

main:
	mov r0,#0x04000000			@ I/O space offset
	mov r1,#0x3					@ Both screens on
	mov r2,#0x00020000			@ Framebuffer mode
	mov r3,#0x80				@ VRAM bank A enabled, LCD
 
	str r1,[r0, #0x304]			@ Set POWERCNT
	str r2,[r0]					@     DISPCNT 
	str r3,[r0, #0x240]			@     VRAMCNT_A
	
	mov r0,#0x06800000			@ make r0 a pointer to screen memory VRAM is 0x06800000.
	ldr r1,=picBitmap			@ make r1 a pointer to your bitmap data
	mov r3,#0x6000				@ Half of 96k (2 pixels at a time)

loop:
	ldr r2,[r1],#4				@ Loads r2 with the next two pixels from the bitmap data (pointed to by r1).
	str r2,[r0],#4				@ Write two pixels
	subs r3,r3,#1				@ Move along one
	bne loop					@ And loop back if not done

nf: b nf						@ Sit in an infinite loop to finish
