#include "system.h"
#include "video.h"
#include "background.h"
#include "dma.h"
#include "interrupts.h"
#include "sprite.h"
#include "ipc.h"

	.arm
	.align
	.global initSystem
	.global main

initSystem:
	bx lr

main:
	ldr r0, =REG_POWERCNT
	ldr r1, =POWER_ALL_2D			@ All power on
	str r1, [r0]
	 
	mov r0, #REG_DISPCNT			@ Main screen to framebuffer mode
	ldr r1, =(MODE_FB0)
	str r1, [r0]
	
	ldr r0, =REG_DISPCNT_SUB		@ Sub screen to framebuffer mode
	ldr r1, =(MODE_FB0)
	str r1, [r0]
 
	ldr r0, =VRAM_A_CR				@ Set VRAM A to be LCD
	ldr r1, =(VRAM_ENABLE | VRAM_A_LCD)
	strb r1, [r0]
	
	ldr r0, =VRAM_C_CR				@ Set VRAM C to be LCD
	ldr r1, =(VRAM_ENABLE | VRAM_C_LCD)
	strb r1, [r0]

@ Clear the IPC

	ldr r0, =0
	ldr r1, =IPC
	ldr r2, =64						@ Should be enough (64 * 4 = 256)
	bl dmaFillWords
	
loop:
	ldr r0, =REG_VCOUNT
	
waitVBlank:									
	ldrh r2, [r0]					@ read REG_VCOUNT into r2
	cmp r2, #(SCREEN_HEIGHT + 1)	@ 193 is, of course, the first scanline of vblank
	bne waitVBlank					@ loop if r2 is not equal to (NE condition) 193
	
	ldr r1, =REG_KEYINPUT			@ Read the keys!
	ldrh r2, [r1]					@ R2 is the input (except X and Y handled by ARM7)
	tst r2, #KEY_A					@ A Button
	bleq playBlaster
	
	ldrh r2, [r1]					@ R2 is the input (except X and Y handled by ARM7)
	tst r2, #KEY_B					@ B Button
	bleq playSaberOff
	
	b loop
	
playBlaster:
	stmfd sp!, {r0-r1, lr}

	ldr r0, =IPC_SOUND_LEN(0)		@ Get the IPC sound length address
	ldr r1, =blaster_raw_size		@ Get the sample size
	str r1, [r0]					@ Write the sample size
	
	ldr r0, =IPC_SOUND_DATA(0)		@ Get the IPC sound data address
	ldr r1, =blaster_raw			@ Get the sample address
	str r1, [r0]					@ Write the value
	
	ldmfd sp!, {r0-r1, pc} 		@ restore rgisters and return
	
playSaberOff:
	stmfd sp!, {r0-r1, lr}

	ldr r0, =IPC_SOUND_LEN(0)		@ Get the IPC sound length address
	ldr r1, =saberoff_raw_size		@ Get the sample size
	str r1, [r0]					@ Write the sample size
	
	ldr r0, =IPC_SOUND_DATA(0)		@ Get the IPC sound data address
	ldr r1, =saberoff_raw			@ Get the sample address
	str r1, [r0]					@ Write the value
	
	ldmfd sp!, {r0-r1, pc} 		@ restore rgisters and return
	
.pool
.end
