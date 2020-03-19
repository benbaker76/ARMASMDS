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
