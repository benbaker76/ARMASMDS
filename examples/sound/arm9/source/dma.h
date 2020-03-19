#define BIT(n) (1<<(n))

#define DMA0_SRC       0x040000B0
#define DMA0_DEST      0x040000B4
#define DMA0_CR        0x040000B8

#define DMA1_SRC       0x040000BC
#define DMA1_DEST      0x040000C0
#define DMA1_CR        0x040000C4

#define DMA2_SRC       0x040000C8
#define DMA2_DEST      0x040000CC
#define DMA2_CR        0x040000D0

#define DMA3_SRC       0x040000D4
#define DMA3_DEST      0x040000D8
#define DMA3_CR        0x040000DC


#define DMA_SRC(n)     (0x040000B0+(n*12))
#define DMA_DEST(n)    (0x040000B4+(n*12))
#define DMA_CR(n)      (0x040000B8+(n*12))

#define DMA_FILL(n)    (0x040000E0+(n*4))

@ DMA control register contents
@ The defaults are 16-bit, increment source/dest addresses, no irq
#define DMA_ENABLE      BIT(31)
#define DMA_BUSY	    BIT(31)
#define DMA_IRQ_REQ     BIT(30)

#define DMA_START_NOW   0
#define DMA_START_CARD  (5<<27)

#define DMA_START_HBL   BIT(28)
#define DMA_START_VBL   BIT(27)
#define DMA_START_FIFO	(7<<27)
#define DMA_DISP_FIFO	(4<<27)

#define DMA_16_BIT      0
#define DMA_32_BIT      BIT(26)

#define DMA_REPEAT      BIT(25)

#define DMA_SRC_INC     (0)
#define DMA_SRC_DEC     BIT(23)
#define DMA_SRC_FIX     BIT(24)

#define DMA_DST_INC     (0)
#define DMA_DST_DEC     BIT(21)
#define DMA_DST_FIX     BIT(22)
#define DMA_DST_RESET   (3<<21)

#define DMA_COPY_WORDS     (DMA_ENABLE | DMA_32_BIT | DMA_START_NOW)
#define DMA_COPY_HALFWORDS (DMA_ENABLE | DMA_16_BIT | DMA_START_NOW)
#define DMA_FIFO	(DMA_ENABLE | DMA_32_BIT  | DMA_DST_FIX | DMA_START_FIFO)

@  void dmaCopyWords(uint8 channel, const void* src, void* dest, uint32 size)
@  copies from source to destination on one of the 4 available channels in words
@ r0 channel the dma channel to use (0 - 3).  
@ r1 src the source to copy from
@ r2 dest the destination to copy to
@ r3 size the size in bytes of the data to copy.  Will be truncated to the nearest word (4 bytes)
@
@dmaCopyWords:
@	stmfd sp!, {r4-r5, lr}				@ save
@	ldr r4, =DMA_SRC(r0)
@	str r1, [r4]
@	ldr r4, =DMA_DEST(r0)
@	str r2, [r4]
@	ldr r4, =DMA_CR(r0)
@	ldr r5, =DMA_COPY_WORDS | (r3>>2)
@	str r5, [r4]
@	ldmfd sp!, {r4-r5, pc}				@ restore and
@	bl dmaWait
@	bx lr								@ return

@  void dmaCopyHalfWords(uint8 channel, const void* src, void* dest, uint32 size)
@  copies from source to destination on one of the 4 available channels in half words
@ r0 channel the dma channel to use (0 - 3).  
@ r1 src the source to copy from
@ r2 dest the destination to copy to
@ r3 size the size in bytes of the data to copy.  Will be truncated to the nearest half word (2 bytes)
@
@dmaCopyHalfWords:
@	stmfd sp!, {r4-r5, lr}				@ save
@	ldr r4, =DMA_SRC(r0)
@	str r1, [r4]
@	ldr r4, =DMA_DEST(r0)
@	str r2, [r4]
@	ldr r4, =DMA_CR(r0)
@	ldr r5, =DMA_COPY_HALFWORDS | (r3>>1)
@	str r5, [r4]
@	ldmfd sp!, {r4-r5, pc}				@ restore and
@	bl dmaWait
@	bx lr								@ return

@  void dmaCopy(const void * source, void * dest, uint32 size)
@  copies from source to destination using channel 3 of DMA available channels in half words  
@ r0 source the source to copy from
@ r1 dest the destination to copy to
@ r2 size the size in bytes of the data to copy.  Will be truncated to the nearest half word (2 bytes)
@
dmaCopy:
	stmfd sp!, {r3-r4, lr}				@ save
	ldr r3, =DMA_SRC(3)
	str r0, [r3]
	ldr r3, =DMA_DEST(3)
	str r1, [r3]
	ldr r3, =DMA_CR(3)
	ldr r4, =DMA_COPY_HALFWORDS
	orr r4, r2, ror #1
	str r4, [r3]
	bl dmaWait
	ldmfd sp!, {r3-r4, pc}				@ restore and

@  void dmaCopyWordsAsynch(uint8 channel, const void* src, void* dest, uint32 size)
@  copies from source to destination on one of the 4 available channels in half words.  
@ This function returns immediately after starting the transfer.
@ r0 channel the dma channel to use (0 - 3).  
@ r1 src the source to copy from
@ r2 dest the destination to copy to
@ r3 size the size in bytes of the data to copy.  Will be truncated to the nearest word (4 bytes)
@
@dmaCopyWordsAsynch:
@	stmfd sp!, {r3-r4, lr}				@ save
@	ldr r3, =DMA_SRC(r0)
@	str r1, [r3]
@	ldr r3, =DMA_DEST(r0)
@	str r2, [r3]
@	ldr r3, =DMA_CR(r0)
@	ldr r4, =DMA_COPY_WORDS | (r3>>2)
@	str r4, [r3]
@	ldmfd sp!, {r3-r4, pc}				@ restore and
@	bx lr								@ return

@  void dmaCopyHalfWordsAsynch(uint8 channel, const void* src, void* dest, uint32 size)
@  copies from source to destination on one of the 4 available channels in half words.  
@ This function returns immediately after starting the transfer.
@ r0 channel the dma channel to use (0 - 3).  
@ r1 src the source to copy from
@ r2 dest the destination to copy to
@ r3 size the size in bytes of the data to copy.  Will be truncated to the nearest half word (2 bytes)
@
@dmaCopyHalfWordsAsynch:
@	stmfd sp!, {r3-r4, lr}				@ save
@	ldr r3, =DMA_SRC(r0)
@	str r1, [r3]
@	ldr r3, =DMA_DEST(r0)
@	str r2, [r3]
@	ldr r3, =DMA_CR(r0)
@	ldr r4, =DMA_COPY_HALFWORDS | (r3>>1)
@	str r4, [r3]
@	ldmfd sp!, {r3-r4, pc}				@ restore and
@	bx lr								@ return

@  void dmaCopyAsynch(const void* src, void* dest, uint32 size)
@  copies from source to destination using channel 3 of DMA available channels in half words.  
@ This function returns immediately after starting the transfer.
@ r0 src the source to copy from
@ r1 dest the destination to copy to
@ r2 size the size in bytes of the data to copy.  Will be truncated to the nearest half word (2 bytes)
@
dmaCopyAsynch:
	stmfd sp!, {r3-r4, lr}				@ save
	ldr r3, =DMA_SRC(3)
	str r0, [r3]
	ldr r3, =DMA_DEST(3)
	str r1, [r3]
	ldr r3, =DMA_CR(3)
	ldr r4, =DMA_COPY_HALFWORDS
	orr r4, r2, ror #1
	str r4, [r3]
	ldmfd sp!, {r3-r4, pc}				@ restore and
	bl dmaWait
	bx lr								@ return

@  void dmaFillWords( u32 value, void* dest, uint32 size)
@  fills the source with the supplied value using DMA channel 3
@
@ r0 value the 32 byte value to fill memory with
@ r1 dest the destination to copy to
@ r2 size the size in bytes of the area to fill.  Will be truncated to the nearest word (4 bytes)
@
dmaFillWords:
	stmfd sp!, {r3-r4, lr}				@ save
	ldr r3, =DMA_FILL(3)
	str r0, [r3]
	ldr r3, =DMA_SRC(3)
	ldr r4, =DMA_FILL(3)
	str r4, [r3]
	ldr r3, =DMA_DEST(3)
	str r1, [r3]
	ldr r3, =DMA_CR(3)
	ldr r4, =DMA_SRC_FIX | DMA_COPY_WORDS
	orr r4, r2, ror #1
	str r4, [r3]
	bl dmaWait
	ldmfd sp!, {r3-r4, pc}				@ restore and return

@  void dmaFillHalfWords( u16 value, void* dest, uint32 size)
@  fills the source with the supplied value using DMA channel 3
@
@ r0 value the 16 byte value to fill memory with
@ r1 dest the destination to copy to
@ r2 size the size in bytes of the area to fill.  Will be truncated to the nearest half word (2 bytes)
@
dmaFillHalfWords:
	stmfd sp!, {r3-r4, lr}				@ save
	ldr r3, =DMA_FILL(3)
	str r0, [r3]
	ldr r3, =DMA_SRC(3)
	ldr r4, =DMA_FILL(3)
	str r4, [r3]
	ldr r3, =DMA_DEST(3)
	str r1, [r3]
	ldr r3, =DMA_CR(3)
	ldr r4, =DMA_SRC_FIX | DMA_COPY_HALFWORDS
	orr r4, r2, ror #1
	str r4, [r3]
	mov r0, #3
	bl dmaWait
	ldmfd sp!, {r3-r4, pc}				@ restore and return

@  Wait for dmaCopy to complete
@ r0 channel the dma channel to use (0 - 3).
dmaWait:
	stmfd sp!, {r2, lr}				@ save
dmaWaitLoop:
	mov r2, #0
	cmp r2, #(DMA_CR(3) & DMA_BUSY)
	bne dmaWaitLoop
	ldmfd sp!, {r2, pc}				@ restore and return

@  dma busy?
@ r0 channel the dma channel to use (0 - 3).
@ r1 return value
@dmaWait:
@	mov	r1, #(DMA_CR(r0) & DMA_BUSY)
@	ror r1, #31
@	bx lr

