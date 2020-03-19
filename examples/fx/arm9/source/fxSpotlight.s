#include "system.h"
#include "video.h"
#include "background.h"
#include "dma.h"
#include "interrupts.h"

	.arm
	.align
	.text
	.global fxSpotlight

fxSpotlight:

	stmfd sp!, {r0-r6, lr}
	
	mov r0, #REG_DISPCNT
	ldr r1, [r0]
	ldr r2, =DISPLAY_WIN0_ON
	orr r1, r2
	str r1, [r0]
	
	ldr r2, =WIN_IN							@ Make bg0 appear inside the window
	ldr r3, =BIT(0)
	strh r3, [r2]
	
	ldr r2, =WIN0_Y0						@ Top pos
	ldr r3, =0
	strb r3, [r2]
	
	ldr r2, =WIN0_Y1						@ Bottom pos
	ldr r3, =192
	strb r3, [r2]
	
	ldr r0, =IRQ_VBLANK
	ldr r1, =fxSpotlightVBlank
	
	bl irqSet
	
	ldmfd sp!, {r0-r6, pc}
	
	@ ---------------------------------------

fxSpotlightVBlank:

	stmfd sp!, {r0-r6, lr}
	
	bl DC_FlushAll							@ Flush the cache for the dma copy
	
	mov r0, #0								@ Clear
	ldr r1, =winh							@ Table address
	ldr r2, =((192 + 1) * 2)				@ Size of table
	
	bl dmaFillWords							@ Clear table
	
	ldr r0, =mode							@ Read the mode
	ldr r0, [r0]
	cmp r0, #0								@ CircleOut
	beq createCircleOut
	cmp r0, #1								@ CircleIn
	beq createCircleIn
	
	b fxSpotlightVBlankDone
	
createCircleOut:
	
	mov r0, #128							@ x position
	mov r1,	#96								@ y position
	ldr r2,	=radius							@ radius
	ldr r2, [r2]
	
	bl createCircleTable
	
	ldr r0,	=radius							@ radius
	ldr r1, =mode							@ mode
	ldr r2, [r0]							@ Read radius value
	add r2, #4								@ Add to radius
	mov r3, #1								@ 1
	cmp r2, #164							@ Radius == 164?
	streq r3, [r1]							@ Yes so set mode to 1
	str r2, [r0]							@ Write back radius
	
	b dmaCircle
	
createCircleIn:

	mov r0, #128							@ x position
	mov r1,	#96								@ y position
	ldr r2,	=radius							@ radius
	ldr r2, [r2]

	bl createCircleTable
	
	ldr r0,	=radius							@ radius
	ldr r1, =mode							@ mode
	ldr r2, [r0]							@ Read radius value
	sub r2, #4								@ Sub from radius
	mov r3, #0								@ 0
	cmp r2, #0								@ Radius == 0?
	streq r3, [r1]							@ Yes so set mode to 0
	str r2, [r0]							@ Write back radius

dmaCircle:

	mov r0, #3								@ Dma channel
	ldr r1, =winh							@ Table with our window values (source)
	add r1, #2								@ &winh[1]
	ldr r2, =REG_WIN0H						@ Horizontal window register (dest)
	mov r3, #1								@ Count
	ldr r4, =(DMA_ENABLE | DMA_REPEAT | DMA_START_HBL | DMA_DST_RESET)
	
	bl dmaTransfer
	
fxSpotlightVBlankDone:

	ldmfd sp!, {r0-r6, pc}
	
	@ ---------------------------------------
	
createCircleTable:

	stmfd sp!, {r0-r7, lr}

	@ r0 - x0 position
	@ r1 - y0 position
	@ r2 - radius
	
	mov r3, #0								@ r3 = x
	mov r4, r2								@ r4 = y (y = radius)
	mov r5, #1
	subs r5, r2								@ r5 = d = 1 - radius 
	mov r6, #0								@ r6 = tmp

createCircleTableLoop:

	@ ---------------- Side octs
	@ ---------------- tmp = clamp(x0 + y, 0, VID_WIDTH);

	push { r0-r2 }							@ Push registers
	
	add r0, r4								@ value = x0 + y
	mov r1, #0								@ min = 0
	mov r2, #256							@ max = 256
	
	bl clamp								@ clamp values
	
	mov r6, r0								@ tmp = clamp
	
	pop { r0-r2 }							@ Pop registers
	
	@ ---------------- tmp += clamp(x0 - y, 0, VID_WIDTH);
	
	push { r0-r2 }							@ Push registers
	
	subs r0, r4								@ value = x0 - y
	mov r1, #0								@ min = 0
	mov r2, #256							@ max = 256
	
	bl clamp								@ clamp values
	
	add r6, r0, lsl #8						@ tmp += clamp << 8
	
	pop { r0-r2 }							@ Pop registers
	
	@ ---------------- IN_RANGE(y0 - x, 0, VID_HEIGHT);
	
	push { r0-r2 }							@ Push registers
	
	subs r0, r1, r3						@ r0 = y0 - x
	mov r1, #0								@ min = 0
	mov r2, #192							@ max = VID_HEIGHT
	
	bl inRange								@ In Range?
	
	ldr r1, =winh							@ winh table
	lsl r0, #1								@ 2 bytes (16 bit) values
	strneh r6, [r1, r0]					@ winh[y0 - x] = tmp
	
	pop { r0-r2 }							@ Pop registers
	
	@ ---------------- IN_RANGE(y0 + x, 0, VID_HEIGHT);
	
	push { r0-r2 }							@ Push registers
	
	add r0, r1, r3							@ r0 = y0 + x
	mov r1, #0								@ min = 0
	mov r2, #192							@ max = VID_HEIGHT
	
	bl inRange								@ In Range?
	
	ldr r1, =winh							@ winh table
	lsl r0, #1								@ 2 bytes (16 bit) values
	strneh r6, [r1, r0]					@ winh[y0 - x] = tmp
	
	pop { r0-r2 }							@ Pop registers
	
	cmp r5, #0								@ if (d >= 0)
	blt jumpTopBottomOcts					@ (d < 0)
	
	@ ---------------- Change in y: top/bottom octs
	@ ---------------- tmp = clamp(x0 + x, 0, VID_WIDTH);

	push { r0-r2 }							@ Push registers
	
	add r0, r3								@ value = x0 + x
	mov r1, #0								@ min = 0
	mov r2, #256							@ max = 256
	
	bl clamp								@ clamp values
	
	mov r6, r0								@ tmp = clamp
	
	pop { r0-r2 }							@ Pop registers
	
	@ ---------------- tmp += clamp(x0 - x, 0, VID_WIDTH);
	
	push { r0-r2 }							@ Push registers
	
	subs r0, r3								@ value = x0 - x
	mov r1, #0								@ min = 0
	mov r2, #256							@ max = 256
	
	bl clamp								@ clamp values
	
	add r6, r0, lsl #8						@ tmp += clamp << 8
	
	pop { r0-r2 }							@ Pop registers
	
	@ ---------------- IN_RANGE(y0 - y, 0, VID_HEIGHT);
	
	push { r0-r2 }							@ Push registers
	
	subs r0, r1, r4						@ r0 = y0 - y
	mov r1, #0								@ min = 0
	mov r2, #192							@ max = VID_HEIGHT
	
	bl inRange								@ In Range?
	
	ldr r1, =winh							@ winh table
	lsl r0, #1								@ 2 bytes (16 bit) values
	strneh r6, [r1, r0]					@ winh[y0 - x] = tmp
	
	pop { r0-r2 }							@ Pop registers
	
	@ ---------------- IN_RANGE(y0 + y, 0, VID_HEIGHT);
	
	push { r0-r2 }							@ Push registers
	
	add r0, r1, r4							@ r0 = y0 + y
	mov r1, #0								@ min = 0
	mov r2, #192							@ max = VID_HEIGHT
	
	bl inRange								@ In Range?
	
	ldr r1, =winh							@ winh table
	lsl r0, #1								@ 2 bytes (16 bit) values
	strneh r6, [r1, r0]					@ winh[y0 - x] = tmp
	
	pop { r0-r2 }							@ Pop registers
	
	subs r4, #1								@ y--
	subs r5, r4, lsl #1						@ d -= ((y--) << 1)
	
	@ ----------------
	
jumpTopBottomOcts:

	push { r0-r2 }							@ Push registers
	
	ldr r0, =winh							@ winh table
	ldrh r1, [r0]
	add r0, #192							@ winh[VID_HEIGHT] = winh[0]
	lsl r0, #1								@ 2 bytes (16 bit) values
	strh r1, [r0]
	
	pop { r0-r2 }							@ Pop registers
	
	@ ----------------

	add r3, #1								@ x++
	add r5, #3								@ d += 3
	add r5, r3, lsl #1						@ d += (((x++) + 3) << 1)
	cmp r4, r3
	bge createCircleTableLoop				@ while (y >= x)

	ldmfd sp!, {r0-r7, pc}
	
	@ ---------------------------------------
	
inRange:

	@ return ((value) >= (min) && (value) < (max));
	@ r0 = value
	@ r1 = min
	@ r2 = max
	@ return value sets Z
	
	push {r3-r4}
	
	mov r3, #0								@ reset result
	mov r4, #0								@ reset result
	cmp r0, r1
	movge r3, #1							@ if (value >= min) r3 = 1
	cmp r0, r2
	movlt r4, #1							@ (value < max) r4 = 1
	and r3, r4								@ r3 and r4
	cmp r3, #0								@ set Z to true or false

	pop {r3-r4}
	
	bx lr
	
	@ ---------------------------------------

clamp:

	@ return ((value) >= (max) ? ((max) - 1) : (((value) < (min)) ? (min) : (value)));
	@ r0 = value
	@ r1 = min
	@ r2 = max
	@ r0 = return value (value clamped)
	
	push {r3-r4}
	
	mov r3, #0								@ reset result
	mov r4, #0								@ reset result
	cmp r0, r2								@ if (value >= max)
	subge r0, r2, #1						@ r3 = max - 1
	bge clampDone							@ condition met so done
	
	cmp r0, r1
	movlt r0, r1							@ (value < min) r0 = min
	movge r0, r0							@ (value >= min) r0 = value
	
clampDone:

	pop {r3-r4}
	
	bx lr

	.data
	.align
	
count:
	.word 0
	
mode:
	.word 0
	
radius:
	.word 0

	.section .bss

winh:
	.space ((192 + 1) * 2)					@ Window values to store into REG_WIN0H

	.pool
	.end
