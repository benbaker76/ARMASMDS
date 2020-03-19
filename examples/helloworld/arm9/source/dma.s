#include "dma.h"

	.arm
	.align
	.text
	.global dmaTransfer
	.global dmaCopyWords
	.global dmaCopyHalfWords
	.global dmaCopy
	.global dmaCopyWordsAsync
	.global dmaCopyHalfWordsAsync
	.global dmaCopyAsync
	.global dmaFillWords
	.global dmaFillHalfWords

	@ ---------------------------------------------

	@  void dmaTransfer(uint8 channel, const void* src, void* dest, uint32 count, uint32 mode)
	@  copies from source to destination a value for a number of times 
	@ r0 - channel the dma channel to use (0 - 3).  
	@ r1 - src the source to copy from
	@ r2 - dest the destination to copy to
	@ r3 - count the number of times to copy
	@ r4 - mode the bit mask to use

dmaTransfer:
	stmfd sp!, {r5-r7, lr}				@ save
	
	mov r6, #12
	mul r6, r0							@ multiply channel by 12 and store
	ldr r5, =DMA_CR(0)					@ load dma register
	mov r7, #0							@ zero
	str r7, [r5, r6]					@ reset
	ldr r5, =DMA_SRC(0)					@ load src base address
	str r1, [r5, r6]					@ store source
	ldr r5, =DMA_DEST(0)				@ load dest base address
	str r2, [r5, r6]					@ store dest
	ldr r5, =DMA_CR(0)					@ load dma register
	mov r7, r3							@ count
	orr r7, r4							@ count | mode
	str r7, [r5, r6]					@ store
	
	ldmfd sp!, {r5-r7, pc}				@ restore and return
	
	@ ---------------------------------------------

	@  void dmaCopyWords(uint8 channel, const void* src, void* dest, uint32 size)
	@  copies from source to destination on one of the 4 available channels in words
	@ r0 - channel the dma channel to use (0 - 3).  
	@ r1 - src the source to copy from
	@ r2 - dest the destination to copy to
	@ r3 - size the size in bytes of the data to copy.  Will be truncated to the nearest word (4 bytes)

dmaCopyWords:
	stmfd sp!, {r4-r6, lr}				@ save
	
	mov r5, #12
	mul r5, r0							@ multiply channel by 12 and store
	ldr r4, =DMA_SRC(0)					@ load src base address
	str r1, [r4, r5]					@ store source
	ldr r4, =DMA_DEST(0)				@ load dest base address
	str r2, [r4, r5]					@ store dest
	ldr r4, =DMA_CR(0)					@ load dma register
	ldr r6, =DMA_COPY_WORDS				@ load bit mask
	orr r6, r3, lsr #2					@ DMA_COPY_WORDS | (size >> 2)
	str r6, [r4, r5]					@ store
	bl dmaWait							@ wait to finish
	
	ldmfd sp!, {r4-r6, pc}				@ restore and return
	
	@ ---------------------------------------------

	@  void dmaCopyHalfWords(uint8 channel, const void* src, void* dest, uint32 size)
	@  copies from source to destination on one of the 4 available channels in half words
	@ r0 - channel the dma channel to use (0 - 3).  
	@ r1 - src the source to copy from
	@ r2 - dest the destination to copy to
	@ r3 - size the size in bytes of the data to copy.  Will be truncated to the nearest half word (2 bytes)
	
dmaCopyHalfWords:
	stmfd sp!, {r4-r6, lr}				@ save
	
	mov r5, #12
	mul r5, r0							@ multiply channel by 12 and store
	ldr r4, =DMA_SRC(0)					@ load src base address
	str r1, [r4, r5]					@ store source
	ldr r4, =DMA_DEST(0)				@ load dest base address
	str r2, [r4, r5]					@ store dest
	ldr r4, =DMA_CR(0)					@ load dma register
	ldr r6, =DMA_COPY_HALFWORDS			@ load bit mask
	orr r6, r3, lsr #1					@ DMA_COPY_HALFWORDS | (size >> 1)
	str r6, [r4, r5]					@ store
	bl dmaWait							@ wait to finish
	
	ldmfd sp!, {r4-r6, pc}				@ restore and return
	
	@ ---------------------------------------------

	@  void dmaCopy(const void * source, void * dest, uint32 size)
	@  copies from source to destination using channel 3 of DMA available channels in half words  
	@ r0 - source the source to copy from
	@ r1 - dest the destination to copy to
	@ r2 - size the size in bytes of the data to copy.  Will be truncated to the nearest half word (2 bytes)
	
dmaCopy:
	stmfd sp!, {r3-r5, lr}				@ save
	
	ldr r3, =DMA_CR(3)					@ load dma register
	mov r4, #0							@ zero
	str r4, [r3]
	ldr r3, =DMA_SRC(3)					@ source channel 3
	str r0, [r3]						@ store source
	ldr r3, =DMA_DEST(3)				@ dest channel 3
	str r1, [r3]						@ store dest
	ldr r3, =DMA_CR(3)					@ load dma register
	ldr r4, =DMA_COPY_HALFWORDS			@ load mask
	orr r4, r2, lsr #1					@ DMA_COPY_HALFWORDS | (size >> 1)
	str r4, [r3]						@ store
	push {r0}
	mov r0, #3							@ r0 = #3
	bl dmaWait							@ wait on channel 3
	pop {r0}
	
	ldmfd sp!, {r3-r5, pc}				@ restore and return
	
	@ ---------------------------------------------

	@  void dmaCopyWordsAsync(uint8 channel, const void* src, void* dest, uint32 size)
	@  copies from source to destination on one of the 4 available channels in half words.  
	@ This function returns immediately after starting the transfer.
	@ r0 - channel the dma channel to use (0 - 3).  
	@ r1 - src the source to copy from
	@ r2 - dest the destination to copy to
	@ r3 - size the size in bytes of the data to copy.  Will be truncated to the nearest word (4 bytes)

dmaCopyWordsAsync:
	stmfd sp!, {r3-r4, lr}				@ save
	
	mov r5, #12
	mul r5, r0							@ multiply channel by 12 and store
	ldr r4, =DMA_SRC(0)					@ load src base address
	add r4, r5							@ add offset
	str r1, [r4]						@ store source
	ldr r4, =DMA_DEST(0)				@ load dest base address
	add r4, r5							@ add offset
	str r2, [r4]						@ store dest
	ldr r4, =DMA_CR(0)					@ load dma register
	add r4, r5							@ add offset
	ldr r6, =DMA_COPY_WORDS				@ load bit mask
	orr r6, r3, lsr #2					@ DMA_COPY_WORDS | (size >> 2)
	str r6, [r4]						@ store
	
	ldmfd sp!, {r3-r4, pc}				@ restore and return
	
	@ ---------------------------------------------

	@  void dmaCopyHalfWordsAsync(uint8 channel, const void* src, void* dest, uint32 size)
	@  copies from source to destination on one of the 4 available channels in half words.  
	@ This function returns immediately after starting the transfer.
	@ r0 - channel the dma channel to use (0 - 3).  
	@ r1 - src the source to copy from
	@ r2 - dest the destination to copy to
	@ r3 - size the size in bytes of the data to copy.  Will be truncated to the nearest half word (2 bytes)
	
dmaCopyHalfWordsAsync:
	stmfd sp!, {r3-r4, lr}				@ save
	
	mov r5, #12
	mul r5, r0							@ multiply channel by 12 and store
	ldr r4, =DMA_SRC(0)					@ load src base address
	str r1, [r4, r5]					@ store source
	ldr r4, =DMA_DEST(0)				@ load dest base address
	str r2, [r4, r5]					@ store dest
	ldr r4, =DMA_CR(0)					@ load dma register
	ldr r6, =DMA_COPY_HALFWORDS			@ load bit mask
	orr r6, r3, lsr #1					@ DMA_COPY_HALFWORDS | (size >> 1)
	str r6, [r4, r5]					@ store
	
	ldmfd sp!, {r3-r4, pc}				@ restore and return
	
	@ ---------------------------------------------

	@  void dmaCopyAsync(const void* src, void* dest, uint32 size)
	@  copies from source to destination using channel 3 of DMA available channels in half words.  
	@ This function returns immediately after starting the transfer.
	@ r0 - src the source to copy from
	@ r1 - dest the destination to copy to
	@ r2 - size the size in bytes of the data to copy.  Will be truncated to the nearest half word (2 bytes)
	
dmaCopyAsync:
	stmfd sp!, {r3-r4, lr}				@ save
	
	ldr r3, =DMA_SRC(3)					@ source channel 3
	str r0, [r3]						@ store source
	ldr r3, =DMA_DEST(3)				@ dest channel 3
	str r1, [r3]						@ store dest
	ldr r3, =DMA_CR(3)					@ load dma register
	ldr r4, =DMA_COPY_HALFWORDS			@ load mask
	orr r4, r2, lsr #1					@ DMA_COPY_HALFWORDS | (size >> 1)
	str r4, [r3]						@ store
	
	ldmfd sp!, {r3-r4, pc}				@ restore and return
	
	@ ---------------------------------------------

	@  void dmaFillWords( u32 value, void* dest, uint32 size)
	@  fills the source with the supplied value using DMA channel 3
	@
	@ r0 - value the 32 byte value to fill memory with
	@ r1 - dest the destination to copy to
	@ r2 - size the size in bytes of the area to fill.  Will be truncated to the nearest word (4 bytes)

dmaFillWords:
	stmfd sp!, {r3-r5, lr}				@ save
	
	ldr r3, =DMA_CR(3)					@ load dma register
	mov r4, #0							@ zero
	str r4, [r3]						@ reset
	ldr r3, =DMA_FILL(3)				@ fill register
	str r0, [r3]						@ store value
	ldr r3, =DMA_SRC(3)					@ source
	ldr r4, =DMA_FILL(3)
	str r4, [r3]
	ldr r3, =DMA_DEST(3)
	str r1, [r3]
	ldr r3, =DMA_CR(3)
	ldr r4, =(DMA_SRC_FIX | DMA_COPY_WORDS)
	orr r4, r2, lsr #2
	str r4, [r3]
	push {r0}
	mov r0, #3							@ move dma channel to r0
	bl dmaWait							@ wait for channel 3
	pop {r0}
	
	ldmfd sp!, {r3-r5, pc}				@ restore and return
	
	@ ---------------------------------------------

	@  void dmaFillHalfWords( u16 value, void* dest, uint32 size)
	@  fills the source with the supplied value using DMA channel 3
	@
	@ r0 - value the 16 byte value to fill memory with
	@ r1 - dest the destination to copy to
	@ r2 - size the size in bytes of the area to fill.  Will be truncated to the nearest half word (2 bytes)

dmaFillHalfWords:
	stmfd sp!, {r3-r5, lr}				@ save
	
	ldr r3, =DMA_FILL(3)				@ fill register
	str r0, [r3]						@ store value
	ldr r3, =DMA_SRC(3)					@ source
	ldr r4, =DMA_FILL(3)
	str r4, [r3]
	ldr r3, =DMA_DEST(3)
	str r1, [r3]
	ldr r3, =DMA_CR(3)
	ldr r4, =(DMA_SRC_FIX | DMA_COPY_HALFWORDS)
	orr r4, r2, lsr #1
	str r4, [r3]
	push {r0}
	mov r0, #3							@ move dma channel to r0
	bl dmaWait							@ wait for channel 3
	pop {r0}
	
	ldmfd sp!, {r3-r5, pc}				@ restore and return
	
	@ ---------------------------------------------

	@  dmaWait for dmaCopy to complete
	@ r0 - channel the dma channel to use (0 - 3).

dmaWait:

	stmfd sp!, {r0-r3, lr}				@ save

	mov r1, #12
	mul r1, r0
	ldr r2, =DMA_CR(0)

dmaWaitLoop:

	ldr r3, [r2, r1]					@ read the value
	tst r3, #DMA_BUSY					@ test busy bit
	bne dmaWaitLoop						@ set so loop
	
	ldmfd sp!, {r0-r3, pc}				@ restore and return
	
	@ ---------------------------------------------
	
	.pool
	.end
	