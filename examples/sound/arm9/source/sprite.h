@ Sprite control defines

@ Attribute 0 consists of 8 bits of Y plus the following flags:
#define ATTR0_NORMAL			(0<<8)
#define ATTR0_ROTSCALE			(1<<8)
#define ATTR0_DISABLED			(2<<8)
#define ATTR0_ROTSCALE_DOUBLE	(3<<8)

#define ATTR0_TYPE_NORMAL		(0<<10)
#define ATTR0_TYPE_BLENDED		(1<<10)
#define ATTR0_TYPE_WINDOWED		(2<<10)
#define ATTR0_BMP				(3<<10)

#define ATTR0_MOSAIC			(1<<12)

#define ATTR0_COLOR_16		(0<<13)
#define ATTR0_COLOR_256		(1<<13)

#define ATTR0_SQUARE		(0<<14)
#define ATTR0_WIDE			(1<<14)
#define ATTR0_TALL			(2<<14)

#define OBJ_Y(m)			((m)&0x00ff)

@ Atribute 1 consists of 9 bits of X plus the following flags:
#define ATTR1_ROTDATA(n)      ((n)<<9)
#define ATTR1_FLIP_X          (1<<12)
#define ATTR1_FLIP_Y          (1<<13)
#define ATTR1_SIZE_8          (0<<14)
#define ATTR1_SIZE_16         (1<<14)
#define ATTR1_SIZE_32         (2<<14)
#define ATTR1_SIZE_64         (3<<14)

#define OBJ_X(m)			((m)&0x01ff)

@ Atribute 2 consists of the following:
#define ATTR2_PRIORITY(n)     ((n)<<10)
#define ATTR2_PALETTE(n)      ((n)<<12)
#define ATTR2_ALPHA(n)		  ((n)<<12)

@ brief The blending mode of the sprite

#define OBJMODE_NORMAL			0
#define OBJMODE_BLENDED			1
#define OBJMODE_WINDOWED		2
#define OBJMODE_BITMAP			3
 
@ brief The shape of the sprite

#define OBJSHAPE_SQUARE			0
#define OBJSHAPE_WIDE			1
#define OBJSHAPE_TALL			2
#define OBJSHAPE_FORBIDDEN		3
 
@ brief The size of the sprite

#define OBJSIZE_8				0
#define OBJSIZE_16				1
#define OBJSIZE_32				2
#define OBJSIZE_64				3

@ brief The color mode of the sprite
#define OBJCOLOR_16				0
#define OBJCOLOR_256			1

@ brief The priority of the sprite
#define OBJPRIORITY_0			0
#define OBJPRIORITY_1			1
#define OBJPRIORITY_2			2
#define OBJPRIORITY_3			3

#define SPRITE_COUNT 128
#define MATRIX_COUNT 32

@ SpriteSize

#define SPRITESIZE_8x8   = (OBJSIZE_8 << 14) | (OBJSHAPE_SQUARE << 12) | (8*8>>5)
#define SPRITESIZE_16x16 = (OBJSIZE_16 << 14) | (OBJSHAPE_SQUARE << 12) | (16*16>>5)
#define SPRITESIZE_32x32 = (OBJSIZE_32 << 14) | (OBJSHAPE_SQUARE << 12) | (32*32>>5)
#define SPRITESIZE_64x64 = (OBJSIZE_64 << 14) | (OBJSHAPE_SQUARE << 12) | (64*64>>5)

#define SPRITESIZE_16x8  = (OBJSIZE_8 << 14)  | (OBJSHAPE_WIDE << 12) | (16*8>>5)
#define SPRITESIZE_32x8  = (OBJSIZE_16 << 14) | (OBJSHAPE_WIDE << 12) | (32*8>>5)
#define SPRITESIZE_32x16 = (OBJSIZE_32 << 14) | (OBJSHAPE_WIDE << 12) | (32*16>>5)
#define SPRITESIZE_64x32 = (OBJSIZE_64 << 14) | (OBJSHAPE_WIDE << 12) | (64*32>>5)

#define SPRITESIZE_8x16  = (OBJSIZE_8 << 14)  | (OBJSHAPE_TALL << 12) | (8*16>>5)
#define SPRITESIZE_8x32  = (OBJSIZE_16 << 14) | (OBJSHAPE_TALL << 12) | (8*32>>5)
#define SPRITESIZE_16x32 = (OBJSIZE_32 << 14) | (OBJSHAPE_TALL << 12) | (16*32>>5)
#define SPRITESIZE_32x64 = (OBJSIZE_64 << 14) | (OBJSHAPE_TALL << 12) | (32*64>>5)

@ SpriteMapping

#define SPRITEMAPPING_1D_32 = DISPLAY_SPR_1D | DISPLAY_SPR_1D_SIZE_32 | (0 << 28) | 0
#define SPRITEMAPPING_1D_64 = DISPLAY_SPR_1D | DISPLAY_SPR_1D_SIZE_64 | (1 << 28) | 1
#define SPRITEMAPPING_1D_128 = DISPLAY_SPR_1D | DISPLAY_SPR_1D_SIZE_128 | (2 << 28) | 2
#define SPRITEMAPPING_1D_256 = DISPLAY_SPR_1D | DISPLAY_SPR_1D_SIZE_256 | (3 << 28) | 3
#define SPRITEMAPPING_2D = DISPLAY_SPR_2D | (4 << 28)
#define SPRITEMAPPING_BMP_1D_128 = DISPLAY_SPR_1D | DISPLAY_SPR_1D_SIZE_128 | DISPLAY_SPR_1D_BMP |DISPLAY_SPR_1D_BMP_SIZE_128 | (5 << 28) | 2
#define SPRITEMAPPING_BMP_1D_256 = DISPLAY_SPR_1D | DISPLAY_SPR_1D_SIZE_256 | DISPLAY_SPR_1D_BMP |DISPLAY_SPR_1D_BMP_SIZE_256 | (6 << 28) | 3
#define SPRITEMAPPING_BMP_2D_128 = DISPLAY_SPR_2D | DISPLAY_SPR_2D_BMP_128 | (7 << 28) | 2
#define SPRITEMAPPING_BMP_2D_256 = DISPLAY_SPR_2D | DISPLAY_SPR_2D_BMP_256 | (8 << 28) | 3

@ SpriteColorFormat

#define SPRITECOLORFORMAT_16COLOR = OBJCOLOR_16
#define SPRITECOLORFORMAT_256COLOR = OBJCOLOR_256
#define SPRITECOLORFORMAT_BMP = OBJMODE_BITMAP

@ OAM Entry attributes

#define OBJ_ATTRIBUTE0(n)			(((n)*0x8) + 0x07000000)
#define OBJ_ATTRIBUTE1(n)			(((n)*0x8) + 0x07000002)
#define OBJ_ATTRIBUTE2(n)			(((n)*0x8) + 0x07000004)

#define OBJ_ATTRIBUTE0_SUB(n)		(((n)*0x8) + 0x07000400)
#define OBJ_ATTRIBUTE1_SUB(n)		(((n)*0x8) + 0x07000402)
#define OBJ_ATTRIBUTE2_SUB(n)		(((n)*0x8) + 0x07000404)

@ Rotation and Scaling data (maximum of 32)

#define OBJ_ROTATION_HDX(n)			(((n)*0x20) + 0x07000006)
#define OBJ_ROTATION_HDY(n)			(((n)*0x20) + 0x0700000E)
#define OBJ_ROTATION_VDX(n)			(((n)*0x20) + 0x07000016)
#define OBJ_ROTATION_VDY(n)			(((n)*0x20) + 0x0700001E)

#define OBJ_ROTATION_HDX_SUB(n)		(((n)*0x20) + 0x07000406)
#define OBJ_ROTATION_HDY_SUB(n)		(((n)*0x20) + 0x0700040E)
#define OBJ_ROTATION_VDX_SUB(n)		(((n)*0x20) + 0x07000416)
#define OBJ_ROTATION_VDY_SUB(n)		(((n)*0x20) + 0x0700041E)
