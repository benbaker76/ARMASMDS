@ 16 bit
#define BG_PALETTE       	0x05000000	@ background palette memory
#define BG_PALETTE_SUB   	0x05000400	@ background palette memory (sub engine)

#define SPRITE_PALETTE		0x05000200	@ sprite palette memory
#define SPRITE_PALETTE_SUB	0x05000600	@ sprite palette memory (sub engine)

#define BG_GFX				0x6000000	@ background graphics memory
#define BG_GFX_SUB			0x6200000	@ background graphics memory (sub engine)
#define SPRITE_GFX			0x6400000	@ sprite graphics memory
#define SPRITE_GFX_SUB		0x6600000	@ sprite graphics memory (sub engine)

#define VRAM_0        0x6000000
#define VRAM          0x6800000

#define VRAM_A        0x6800000		@ pointer to vram bank A mapped as LCD
#define VRAM_B        0x6820000		@ pointer to vram bank B mapped as LCD
#define VRAM_C        0x6840000		@ pointer to vram bank C mapped as LCD
#define VRAM_D        0x6860000		@ pointer to vram bank D mapped as LCD
#define VRAM_E        0x6880000		@ pointer to vram bank E mapped as LCD
#define VRAM_F        0x6890000		@ pointer to vram bank F mapped as LCD
#define VRAM_G        0x6894000		@ pointer to vram bank G mapped as LCD
#define VRAM_H        0x6898000		@ pointer to vram bank H mapped as LCD
#define VRAM_I        0x68A0000		@ pointer to vram bank I mapped as LCD

#define OAM           0x07000000
#define OAM_SUB       0x07000400

@ macro creates a 15 bit color from 3x5 bit components
@  Macro to convert 5 bit r g b components into a single 15 bit RGB triplet
#define RGB15(r,g,b)  ((r)|((g)<<5)|((b)<<10))
#define RGB5(r,g,b)  ((r)|((g)<<5)|((b)<<10))
#define RGB8(r,g,b)  (((r)>>3)|(((g)>>3)<<5)|(((b)>>3)<<10))
@  Macro to convert 5 bit r g b components plus 1 bit alpha into a single 16 bit ARGB triplet
#define ARGB16(a, r, g, b) ( ((a) << 15) | (r)|((g)<<5)|((b)<<10))

@  Screen height in pixels
#define SCREEN_HEIGHT 192 
@  Screen width in pixels
#define SCREEN_WIDTH  256

@	Vram Control
@ 32 bit
#define VRAM_CR			0x04000240
@ 8 bit
#define VRAM_A_CR		0x04000240
#define VRAM_B_CR		0x04000241
#define VRAM_C_CR		0x04000242
#define VRAM_D_CR		0x04000243
#define VRAM_E_CR		0x04000244
#define VRAM_F_CR		0x04000245
#define VRAM_G_CR		0x04000246
#define WRAM_CR			0x04000247
#define VRAM_H_CR		0x04000248
#define VRAM_I_CR		0x04000249

#define VRAM_ENABLE		(1<<7)

#define VRAM_OFFSET(n)	((n)<<3)

@  Allowed VRAM bank A modes
#define VRAM_A_LCD						0
#define VRAM_A_MAIN_BG					1
#define VRAM_A_MAIN_BG_0x06000000		(1 | VRAM_OFFSET(0))
#define VRAM_A_MAIN_BG_0x06020000		(1 | VRAM_OFFSET(1))
#define VRAM_A_MAIN_BG_0x06040000		(1 | VRAM_OFFSET(2))
#define VRAM_A_MAIN_BG_0x06060000		(1 | VRAM_OFFSET(3))
#define VRAM_A_MAIN_SPRITE				2
#define VRAM_A_MAIN_SPRITE_0x06400000	2
#define VRAM_A_MAIN_SPRITE_0x06420000	(2 | VRAM_OFFSET(1))
#define VRAM_A_TEXTURE					3
#define VRAM_A_TEXTURE_SLOT0			(3 | VRAM_OFFSET(0))
#define VRAM_A_TEXTURE_SLOT1			(3 | VRAM_OFFSET(1))
#define VRAM_A_TEXTURE_SLOT2			(3 | VRAM_OFFSET(2))
#define VRAM_A_TEXTURE_SLOT3			(3 | VRAM_OFFSET(3))

@  Allowed VRAM bank B modes
#define VRAM_B_LCD						0
#define VRAM_B_MAIN_BG					(1 | VRAM_OFFSET(1))
#define VRAM_B_MAIN_BG_0x06000000		(1 | VRAM_OFFSET(0))
#define VRAM_B_MAIN_BG_0x06020000		(1 | VRAM_OFFSET(1))
#define VRAM_B_MAIN_BG_0x06040000		(1 | VRAM_OFFSET(2))
#define VRAM_B_MAIN_BG_0x06060000		(1 | VRAM_OFFSET(3))
#define VRAM_B_MAIN_SPRITE				(2 | VRAM_OFFSET(1))
#define VRAM_B_MAIN_SPRITE_0x06400000	2
#define VRAM_B_MAIN_SPRITE_0x06420000	(2 | VRAM_OFFSET(1))
#define VRAM_B_TEXTURE					(3 | VRAM_OFFSET(1))
#define VRAM_B_TEXTURE_SLOT0			(3 | VRAM_OFFSET(0))
#define VRAM_B_TEXTURE_SLOT1			(3 | VRAM_OFFSET(1))
#define VRAM_B_TEXTURE_SLOT2			(3 | VRAM_OFFSET(2))
#define VRAM_B_TEXTURE_SLOT3			(3 | VRAM_OFFSET(3))

@  Allowed VRAM bank C modes
#define VRAM_C_LCD						0
#define VRAM_C_MAIN_BG					(1 | VRAM_OFFSET(2))
#define VRAM_C_MAIN_BG_0x06000000		(1 | VRAM_OFFSET(0))
#define VRAM_C_MAIN_BG_0x06020000		(1 | VRAM_OFFSET(1))
#define VRAM_C_MAIN_BG_0x06040000		(1 | VRAM_OFFSET(2))
#define VRAM_C_MAIN_BG_0x06060000		(1 | VRAM_OFFSET(3))
#define VRAM_C_ARM7						2
#define VRAM_C_ARM7_0x06000000			2
#define VRAM_C_ARM7_0x06020000			(2 | VRAM_OFFSET(1))
#define VRAM_C_SUB_BG					4
#define VRAM_C_SUB_BG_0x06200000		(4 | VRAM_OFFSET(0))
#define VRAM_C_TEXTURE					(3 | VRAM_OFFSET(2))
#define VRAM_C_TEXTURE_SLOT0			(3 | VRAM_OFFSET(0))
#define VRAM_C_TEXTURE_SLOT1			(3 | VRAM_OFFSET(1))
#define VRAM_C_TEXTURE_SLOT2			(3 | VRAM_OFFSET(2))
#define VRAM_C_TEXTURE_SLOT3			(3 | VRAM_OFFSET(3))

@  Allowed VRAM bank D modes
#define VRAM_D_LCD						0
#define VRAM_D_MAIN_BG  				(1 | VRAM_OFFSET(3))
#define VRAM_D_MAIN_BG_0x06000000		(1 | VRAM_OFFSET(0))
#define VRAM_D_MAIN_BG_0x06020000		(1 | VRAM_OFFSET(1))
#define VRAM_D_MAIN_BG_0x06040000		(1 | VRAM_OFFSET(2))
#define VRAM_D_MAIN_BG_0x06060000		(1 | VRAM_OFFSET(3))
#define VRAM_D_ARM7						(2 | VRAM_OFFSET(1))
#define VRAM_D_ARM7_0x06000000			2
#define VRAM_D_ARM7_0x06020000			(2 | VRAM_OFFSET(1))
#define VRAM_D_SUB_SPRITE				4
#define VRAM_D_TEXTURE					(3 | VRAM_OFFSET(3))
#define VRAM_D_TEXTURE_SLOT0			(3 | VRAM_OFFSET(0))
#define VRAM_D_TEXTURE_SLOT1			(3 | VRAM_OFFSET(1))
#define VRAM_D_TEXTURE_SLOT2			(3 | VRAM_OFFSET(2))
#define VRAM_D_TEXTURE_SLOT3			(3 | VRAM_OFFSET(3))

@  Allowed VRAM bank E modes
#define VRAM_E_LCD             0
#define VRAM_E_MAIN_BG         1
#define VRAM_E_MAIN_SPRITE     2
#define VRAM_E_TEX_PALETTE     3
#define VRAM_E_BG_EXT_PALETTE  4
#define VRAM_E_OBJ_EXT_PALETTE 5

@  Allowed VRAM bank F modes
#define VRAM_F_LCD						0
#define VRAM_F_MAIN_BG					1
#define VRAM_F_MAIN_BG_0x06000000		1
#define VRAM_F_MAIN_BG_0x06004000		(1 | VRAM_OFFSET(1))
#define VRAM_F_MAIN_BG_0x06010000		(1 | VRAM_OFFSET(2))
#define VRAM_F_MAIN_BG_0x06014000		(1 | VRAM_OFFSET(3))
#define VRAM_F_MAIN_SPRITE				2
#define VRAM_F_MAIN_SPRITE_0x06400000	2
#define VRAM_F_MAIN_SPRITE_0x06404000	(2 | VRAM_OFFSET(1))
#define VRAM_F_MAIN_SPRITE_0x06410000	(2 | VRAM_OFFSET(2))
#define VRAM_F_MAIN_SPRITE_0x06414000	(2 | VRAM_OFFSET(3))
#define VRAM_F_TEX_PALETTE				3
#define VRAM_F_BG_EXT_PALETTE			4
#define VRAM_F_BG_EXT_PALETTE_SLOT01	(4 | VRAM_OFFSET(0))
#define VRAM_F_BG_EXT_PALETTE_SLOT23	(4 | VRAM_OFFSET(1))
#define VRAM_F_OBJ_EXT_PALETTE			5

@  Allowed VRAM bank G modes
#define VRAM_G_LCD						0
#define VRAM_G_MAIN_BG					1
#define VRAM_G_MAIN_BG_0x06000000		1
#define VRAM_G_MAIN_BG_0x06004000		(1 | VRAM_OFFSET(1))
#define VRAM_G_MAIN_BG_0x06010000		(1 | VRAM_OFFSET(2))
#define VRAM_G_MAIN_BG_0x06014000		(1 | VRAM_OFFSET(3))
#define VRAM_G_MAIN_SPRITE				2
#define VRAM_G_MAIN_SPRITE_0x06400000	2
#define VRAM_G_MAIN_SPRITE_0x06404000	(2 | VRAM_OFFSET(1))
#define VRAM_G_MAIN_SPRITE_0x06410000	(2 | VRAM_OFFSET(2))
#define VRAM_G_MAIN_SPRITE_0x06414000	(2 | VRAM_OFFSET(3))
#define VRAM_G_TEX_PALETTE				3
#define VRAM_G_BG_EXT_PALETTE			4
#define VRAM_G_BG_EXT_PALETTE_SLOT01	(4 | VRAM_OFFSET(0))
#define VRAM_G_BG_EXT_PALETTE_SLOT23	(4 | VRAM_OFFSET(1))
#define VRAM_G_OBJ_EXT_PALETTE			5

@  Allowed VRAM bank H modes
#define VRAM_H_LCD					0
#define VRAM_H_SUB_BG				1
#define VRAM_H_SUB_BG_EXT_PALETTE	2

@  Allowed VRAM bank I modes
#define VRAM_I_LCD						0
#define VRAM_I_SUB_BG_0x06208000		1
#define VRAM_I_SUB_SPRITE				2
#define VRAM_I_SUB_SPRITE_EXT_PALETTE	3

@  Used for accessing vram E as an external palette
#define VRAM_E_EXT_PALETTE VRAM_E

@  Used for accessing vram F as an external palette
#define VRAM_F_EXT_PALETTE VRAM_F

@  Used for accessing vram G as an external palette
#define VRAM_G_EXT_PALETTE VRAM_G

@  Used for accessing vram H as an external palette
#define VRAM_H_EXT_PALETTE VRAM_H

@ Display control registers
@ 32 bit
#define	REG_DISPCNT		0x04000000
#define	REG_DISPCNT_SUB	0x04001000

#define ENABLE_3D    (1<<3)
#define DISPLAY_ENABLE_SHIFT 8
#define DISPLAY_BG0_ACTIVE    (1 << 8)
#define DISPLAY_BG1_ACTIVE    (1 << 9)
#define DISPLAY_BG2_ACTIVE    (1 << 10)
#define DISPLAY_BG3_ACTIVE    (1 << 11)
#define DISPLAY_SPR_ACTIVE    (1 << 12)
#define DISPLAY_WIN0_ON       (1 << 13)
#define DISPLAY_WIN1_ON       (1 << 14)
#define DISPLAY_SPR_WIN_ON    (1 << 15)

#define MODE_0_2D		0x10000
#define MODE_1_2D		0x10001
#define MODE_2_2D		0x10002
#define MODE_3_2D		0x10003
#define MODE_4_2D		0x10004
#define MODE_5_2D		0x10005
#define MODE_6_2D		0x10006
#define MODE_0_3D		(0x10000 | DISPLAY_BG0_ACTIVE | ENABLE_3D)		@  3 2D backgrounds 1 3D background (Main engine only)
#define MODE_1_3D		(0x10001 | DISPLAY_BG0_ACTIVE | ENABLE_3D)		@  3 2D backgrounds 1 3D background (Main engine only)
#define MODE_2_3D		(0x10002 | DISPLAY_BG0_ACTIVE | ENABLE_3D)		@  3 2D backgrounds 1 3D background (Main engine only)
#define MODE_3_3D		(0x10003 | DISPLAY_BG0_ACTIVE | ENABLE_3D)		@  3 2D backgrounds 1 3D background (Main engine only)
#define MODE_4_3D		(0x10004 | DISPLAY_BG0_ACTIVE | ENABLE_3D)		@  3 2D backgrounds 1 3D background (Main engine only)
#define MODE_5_3D		(0x10005 | DISPLAY_BG0_ACTIVE | ENABLE_3D)		@  3 2D backgrounds 1 3D background (Main engine only)
#define MODE_6_3D		(0x10006 | DISPLAY_BG0_ACTIVE | ENABLE_3D)		@  3 2D backgrounds 1 3D background (Main engine only)

#define MODE_FIFO    (3<<16)	@  video display from main memory

#define MODE_FB0     0x00020000
#define MODE_FB1     0x00060000
#define MODE_FB2	 0x000A0000
#define MODE_FB3	 0x000E0000

@ main display only

#define DISPLAY_SPR_HBLANK	   (1 << 23)

#define DISPLAY_SPR_1D_LAYOUT	(1 << 4)

#define DISPLAY_SPR_1D				(1 << 4)
#define DISPLAY_SPR_2D				(0 << 4)
#define DISPLAY_SPR_1D_BMP			(4 << 4)
#define DISPLAY_SPR_2D_BMP_128		(0 << 4)
#define DISPLAY_SPR_2D_BMP_256		(2 << 4)


#define DISPLAY_SPR_1D_SIZE_32		(0 << 20)
#define DISPLAY_SPR_1D_SIZE_64		(1 << 20)
#define DISPLAY_SPR_1D_SIZE_128		(2 << 20)
#define DISPLAY_SPR_1D_SIZE_256		(3 << 20)
#define DISPLAY_SPR_1D_BMP_SIZE_128	(0 << 22)
#define DISPLAY_SPR_1D_BMP_SIZE_256	(1 << 22)

@mask to clear all attributes related to sprites from display control
#define DISPLAY_SPRITE_ATTR_MASK  ((7 << 4) | (7 << 20) | (1 << 31))

#define DISPLAY_SPR_EXT_PALETTE		(1 << 31)
#define DISPLAY_BG_EXT_PALETTE		(1 << 30)

#define DISPLAY_SCREEN_OFF     (1 << 7)

@ The next two defines only apply to MAIN 2d engine
@ In tile modes, this is multiplied by 64KB and added to BG_TILE_BASE
@ In all bitmap modes, it is not used.
#define DISPLAY_CHAR_BASE(n) (((n)&7)<<24)

@ In tile modes, this is multiplied by 64KB and added to BG_MAP_BASE
@ In bitmap modes, this is multiplied by 64KB and added to BG_BMP_BASE
@ In large bitmap modes, this is not used
#define DISPLAY_SCREEN_BASE(n) (((n)&7)<<27)

#define SCREEN_BASE(n) (n << 8)
#define CHAR_BASE(n) (n << 2)

@ 16 bit
#define REG_MASTER_BRIGHT     0x0400006C
#define REG_MASTER_BRIGHT_SUB 0x0400106C


@ Window 0
@ 8 bit
#define WIN0_X0        0x04000041
#define WIN0_X1        0x04000040
#define WIN0_Y0        0x04000045
#define WIN0_Y1        0x04000044

@ Window 1
@ 8 bit
#define WIN1_X0        0x04000043
#define WIN1_X1        0x04000042
#define WIN1_Y0        0x04000047
#define WIN1_Y1        0x04000046

@ 16 bit
#define WIN_IN         0x04000048
#define WIN_OUT        0x0400004A

@ Window 0
@ 8 bit
#define SUB_WIN0_X0    0x04001041
#define SUB_WIN0_X1    0x04001040
#define SUB_WIN0_Y0    0x04001045
#define SUB_WIN0_Y1    0x04001044

@ Window 1
@ 8 bit
#define SUB_WIN1_X0    0x04001043
#define SUB_WIN1_X1    0x04001042
#define SUB_WIN1_Y0    0x04001047
#define SUB_WIN1_Y1    0x04001046

@ 16 bit
#define SUB_WIN_IN     0x04001048
#define SUB_WIN_OUT    0x0400104A

#define MOSAIC_CR      0x0400004C
#define SUB_MOSAIC_CR  0x0400104C

#define BLEND_CR       0x04000050
#define BLEND_AB       0x04000052
#define BLEND_Y        0x04000054

#define SUB_BLEND_CR   0x04001050
#define SUB_BLEND_AB   0x04001052
#define SUB_BLEND_Y    0x04001054

#define BLEND_NONE         (0<<6)
#define BLEND_ALPHA        (1<<6)
#define BLEND_FADE_WHITE   (2<<6)
#define BLEND_FADE_BLACK   (3<<6)

#define BLEND_SRC_BG0      (1<<0)
#define BLEND_SRC_BG1      (1<<1)
#define BLEND_SRC_BG2      (1<<2)
#define BLEND_SRC_BG3      (1<<3)
#define BLEND_SRC_SPRITE   (1<<4)
#define BLEND_SRC_BACKDROP (1<<5)

#define BLEND_DST_BG0      (1<<8)
#define BLEND_DST_BG1      (1<<9)
#define BLEND_DST_BG2      (1<<10)
#define BLEND_DST_BG3      (1<<11)
#define BLEND_DST_SPRITE   (1<<12)
#define BLEND_DST_BACKDROP (1<<13)

@ Display capture control

@ 32 bit
#define	REG_DISPCAPCNT		0x04000064
#define REG_DISP_MMEM_FIFO	0x04000068

#define DCAP_ENABLE    BIT(31)
#define DCAP_MODE(n)   (((n) & 3) << 29)
#define DCAP_DST(n)    (((n) & 3) << 26)
#define DCAP_SRC(n)    (((n) & 3) << 24)
#define DCAP_SIZE(n)   (((n) & 3) << 20)
#define DCAP_OFFSET(n) (((n) & 3) << 18)
#define DCAP_BANK(n)   (((n) & 3) << 16)
#define DCAP_B(n)      (((n) & 0x1F) << 8)
#define DCAP_A(n)      (((n) & 0x1F) << 0)


@ 3D core control

@ 16 bit
#define GFX_CONTROL           0x04000060

@ 32 bit
#define GFX_FIFO              0x04000400
#define GFX_STATUS            0x04000600
#define GFX_COLOR             0x04000480

#define GFX_VERTEX10          0x04000490
#define GFX_VERTEX_XY         0x04000494
#define GFX_VERTEX_XZ         0x04000498
#define GFX_VERTEX_YZ         0x0400049C
#define GFX_VERTEX_DIFF       0x040004A0

#define GFX_VERTEX16          0x0400048C
#define GFX_TEX_COORD         0x04000488
#define GFX_TEX_FORMAT        0x040004A8
#define GFX_PAL_FORMAT        0x040004AC

#define GFX_CLEAR_COLOR       0x04000350
@ 16 bit
#define GFX_CLEAR_DEPTH       0x04000354

@ 32 bit
#define GFX_LIGHT_VECTOR      0x040004C8
#define GFX_LIGHT_COLOR       0x040004CC
#define GFX_NORMAL            0x04000484

#define GFX_DIFFUSE_AMBIENT   0x040004C0
#define GFX_SPECULAR_EMISSION 0x040004C4
#define GFX_SHININESS         0x040004D0

#define GFX_POLY_FORMAT       0x040004A4
@ 16 bit
#define GFX_ALPHA_TEST        0x04000340

@ 32 bit
#define GFX_BEGIN			0x04000500
#define GFX_END				0x04000504
#define GFX_FLUSH			0x04000540
#define GFX_VIEWPORT		0x04000580
@ 16 bit
#define GFX_TOON_TABLE		0x04000380
#define GFX_EDGE_TABLE		0x04000330
@ 32 bit
#define GFX_FOG_COLOR		0x04000358
#define GFX_FOG_OFFSET		0x0400035C
@ 8 bit
#define GFX_FOG_TABLE		0x04000360
@ 32 bit
#define GFX_BOX_TEST		0x040005C0
#define GFX_POS_TEST		0x040005C4
#define GFX_POS_RESULT		0x04000620
#define GFX_VEC_TEST		0x040005C8
@ 16 bit
#define GFX_VEC_RESULT		0x04000630

#define GFX_BUSY (GFX_STATUS & BIT(27))

#define GFX_VERTEX_RAM_USAGE	0x04000606
#define GFX_POLYGON_RAM_USAGE	0x04000604

#define GFX_CUTOFF_DEPTH		0x04000610

@ Matrix processor control

@ 32 bit
#define MATRIX_CONTROL		0x04000440
#define MATRIX_PUSH			0x04000444
#define MATRIX_POP			0x04000448
#define MATRIX_SCALE		0x0400046C
#define MATRIX_TRANSLATE	0x04000470
#define MATRIX_RESTORE		0x04000450
#define MATRIX_STORE		0x0400044C
#define MATRIX_IDENTITY		0x04000454
#define MATRIX_LOAD4x4		0x04000458
#define MATRIX_LOAD4x3		0x0400045C
#define MATRIX_MULT4x4		0x04000460
#define MATRIX_MULT4x3		0x04000464
#define MATRIX_MULT3x3		0x04000468

@matrix operation results
#define MATRIX_READ_CLIP		0x04000640
#define MATRIX_READ_VECTOR		0x04000680
#define POINT_RESULT			0x04000620
@ 16 bit
#define VECTOR_RESULT			0x04000630
