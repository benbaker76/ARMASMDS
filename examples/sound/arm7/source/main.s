#include "system.h"
#include "audio.h"
#include "ipc.h"

	.arm
	.text
	.global main

main:
	ldr r0, =REG_POWERCNT
	ldr r1, =POWER_SOUND			@ Turn on sound
	str r1, [r0]
	
	ldr r0, =SOUND_CR				@ This just turns on global sound and sets volume
	ldr r1, =(SOUND_ENABLE | SOUND_VOL(127))	@ Turn on sound
	strh r1, [r0]
	
loop:
	ldr r0, =REG_VCOUNT
waitVBlank:									
	ldrh r2, [r0]					@ read REG_VCOUNT into r2
	cmp r2, #193					@ 193 is, of course, the first scanline of vblank
	bne waitVBlank					@ loop if r2 is not equal to (NE condition) 193
	
	ldr r0, =IPC_SOUND_DATA(0)		@ Get a pointer to the sound data in IPC
	ldr r1, [r0]					@ Read the value
	cmp r1, #0						@ Is there data there?
	blne playSound					@ If so lets play the sound
	
	b loop

playSound:
	stmfd sp!, {r0-r2, lr}
	
	ldr r0, =SCHANNEL_TIMER(0)
	ldr r1, =SOUND_FREQ(11025)		@ Frequency currently hard-coded to 11025 Hz
	strh r1, [r0]
	
	ldr r0, =SCHANNEL_SOURCE(0)		@ Channel source
	ldr r1, =IPC_SOUND_DATA(0)		@ Lets get first sound in IPC
	ldr r2, [r1]					@ Read the value
	str r2, [r0]					@ Write the value
	
	ldr r0, =SCHANNEL_LENGTH(0)
	ldr r1, =IPC_SOUND_LEN(0)		@ Get the location of the sound length
	ldr r2, [r1]					@ Read the value
	lsr r2, r2, #3					@ Right shift (LEN >> 2)
	str r2, [r0]					@ Write the value
	
	ldr r0, =SCHANNEL_REPEAT_POINT(0)
	mov r1, #0
	strh r1, [r0]
	
	ldr r0, =SCHANNEL_CR(0)
	ldr r1, =(SCHANNEL_ENABLE | SOUND_ONE_SHOT | SOUND_VOL(127) | SOUND_PAN(64) | SOUND_8BIT)
	str r1, [r0]

	ldr r0, =IPC_SOUND_DATA(0)		@ Get a pointer to the sound data in IPC
	mov r1, #0
	str r1, [r0]					@ Clear the value so it wont play again

	ldmfd sp!, {r0-r2, pc} 		@ restore rgisters and return

.pool
.end
