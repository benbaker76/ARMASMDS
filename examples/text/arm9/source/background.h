#define BIT(n) (1<<(n))

#define MAP_BASE_SHIFT 8
@ The shift to apply to tile base when storing it in a background control register 
#define TILE_BASE_SHIFT 2 
@ Macro to set the tile base in background control 
#define BG_TILE_BASE(base) ((base) << TILE_BASE_SHIFT)
@ Macro to set the map base in background control 
#define BG_MAP_BASE(base)  ((base) << MAP_BASE_SHIFT)
@ Macro to set the graphics base in background control 
#define BG_BMP_BASE(base)  ((base) << MAP_BASE_SHIFT)
@ Macro to set the priority in background control 
#define BG_PRIORITY(n) (n)

@ Macro to set the palette entry of a 16 bit tile index 
#define TILE_PALETTE(n) ((n)<<12)
@ The horizontal flip bit for a 16 bit tile index 
#define TILE_FLIP_H BIT(10)
@ The vertical flip bit for a 16 bit tile index  
#define TILE_FLIP_V BIT(11)

@ Bit defines for the background control registers

#define BG_32x32    (0 << 14)
#define BG_64x32    (1 << 14)
#define BG_32x64    (2 << 14)
#define BG_64x64    (3 << 14)

#define BG_RS_16x16   (0 << 14)
#define BG_RS_32x32   (1 << 14)
#define BG_RS_64x64   (2 << 14)
#define BG_RS_128x128 (3 << 14)

#define BG_BMP8_128x128  ((0 << 14) | BIT(7))
#define BG_BMP8_256x256  ((1 << 14) | BIT(7))
#define BG_BMP8_512x256  ((2 << 14) | BIT(7))
#define BG_BMP8_512x512  ((3 << 14) | BIT(7))
#define BG_BMP8_1024x512 BIT(14)
#define BG_BMP8_512x1024 0

#define BG_BMP16_128x128  ((0 << 14) | BIT(7) | BIT(2))
#define BG_BMP16_256x256  ((1 << 14) | BIT(7) | BIT(2))
#define BG_BMP16_512x256  ((2 << 14) | BIT(7) | BIT(2))
#define BG_BMP16_512x512  ((3 << 14) | BIT(7) | BIT(2))	

#define BG_MOSAIC_ON   (BIT(6))
#define BG_MOSAIC_OFF  (0)

#define BG_PRIORITY_0  (0)
#define BG_PRIORITY_1  (1)
#define BG_PRIORITY_2  (2)
#define BG_PRIORITY_3  (3)

#define BG_WRAP_OFF    (0)
#define BG_WRAP_ON     (1 << 13)

#define BG_PALETTE_SLOT0 0
#define BG_PALETTE_SLOT1 0
#define BG_PALETTE_SLOT2 BIT(13)
#define BG_PALETTE_SLOT3 BIT(13)

#define BG_COLOR_256	0x80
#define BG_COLOR_16		0x00

#define BG_OFFSET		0x04000010
@ A macro which returns a u16* pointer to background map ram (Main Engine) 
#define BG_MAP_RAM(base)		(((base)*0x800) + 0x06000000)
@ A macro which returns a u16* pointer to background tile ram (Main Engine) 
#define BG_TILE_RAM(base)		(((base)*0x4000) + 0x06000000)
@ A macro which returns a u16* pointer to background graphics memory ram (Main Engine) 
#define BG_BMP_RAM(base)		(((base)*0x4000) + 0x06000000)
@ A macro which returns a u16* pointer to background tile ram (Main Engine) 
#define CHAR_BASE_BLOCK(n)		(((n)*0x4000)+ 0x06000000)
@ A macro which returns a u16* pointer to background Map ram (Main Engine) 
#define SCREEN_BASE_BLOCK(n)	(((n)*0x800) + 0x06000000)

@ Access to all Main screen background control registers via: BGCTRL[x] 

#define	BGCTRL			0x4000008
@ Background 0 Control register (main engine)

#define	REG_BG0CNT		0x4000008
@ Background 1 Control register (main engine)

#define	REG_BG1CNT		0x400000A
@ Background 2 Control register (main engine)

#define	REG_BG2CNT		0x400000C
@ Background 3 Control register (main engine)

#define	REG_BG3CNT		0x400000E

#define	REG_BGOFFSETS	0x4000010
@ Background 0 horizontal scroll register (main engine)
#define	REG_BG0HOFS		0x4000010
@ Background 0 vertical scroll register (main engine)
#define	REG_BG0VOFS		0x4000012
@ Background 1 horizontal scroll register (main engine)
#define	REG_BG1HOFS		0x4000014
@ Background 1 vertical scroll register (main engine)
#define	REG_BG1VOFS		0x4000016
@ Background 2 horizontal scroll register (main engine)
#define	REG_BG2HOFS		0x4000018
@ Background 2 vertical scroll register (main engine)
#define	REG_BG2VOFS		0x400001A
@ Background 3 horizontal scroll register (main engine)
#define	REG_BG3HOFS		0x400001C
@ Background 3 vertical scroll register (main engine)
#define	REG_BG3VOFS		0x400001E
@ Background 2 Affine transform (main engine)
#define	REG_BG2PA		0x4000020
@ Background 2 Affine transform (main engine)
#define	REG_BG2PB		0x4000022
@ Background 2 Affine transform (main engine)
#define	REG_BG2PC		0x4000024
@ Background 2 Affine transform (main engine)
#define	REG_BG2PD		0x4000026

@ Background 2 Screen Offset (main engine)
#define	REG_BG2X		0x4000028

@ Background 2 Screen Offset (main engine)
#define	REG_BG2Y		0x400002C
@ Background 3 Affine transform (main engine)
#define	REG_BG3PA		0x4000030
@ Background 3 Affine transform (main engine)
#define	REG_BG3PB		0x4000032
@ Background 3 Affine transform (main engine)
#define	REG_BG3PC		0x4000034
@ Background 3 Affine transform (main engine)
#define	REG_BG3PD		0x4000036

@ Background 3 Screen Offset (main engine)
#define	REG_BG3X		0x4000038

@ Background 3 Screen Offset (main engine)
#define	REG_BG3Y		0x400003C

@ Overlay for sub screen background attributes.  Setting the properties of this 

#define BACKGROUND_SUB      0x04001008
@ Overlay for sub screen background scroll registers.  Setting the properties of this 

#define BG_OFFSET_SUB		0x04001010
@ A macro which returns a u16* pointer to background map ram (Sub Engine) 
#define BG_MAP_RAM_SUB(base)	(((base)*0x800) + 0x06200000)
@ A macro which returns a u16* pointer to background tile ram (Sub Engine) 
#define BG_TILE_RAM_SUB(base)	(((base)*0x4000) + 0x06200000)
@ A macro which returns a u16* pointer to background graphics ram (Sub Engine) 
#define BG_BMP_RAM_SUB(base)	(((base)*0x4000) + 0x06200000)
@ A macro which returns a u16* pointer to background Map ram (Sub Engine) 
#define SCREEN_BASE_BLOCK_SUB(n)	(((n)*0x800) + 0x06200000)
@ A macro which returns a u16* pointer to background tile ram (Sub Engine) 
#define CHAR_BASE_BLOCK_SUB(n)		(((n)*0x4000)+ 0x06200000)

@ Access to all Sub screen background control registers via: BGCTRL[x] 

#define	BGCTRL_SUB			0x4001008
@ Background 0 Control register (sub engine)

#define	REG_BG0CNT_SUB		0x4001008
@ Background 1 Control register (sub engine)

#define	REG_BG1CNT_SUB		0x400100A
@ Background 2 Control register (sub engine)

#define	REG_BG2CNT_SUB		0x400100C
@ Background 3 Control register (sub engine)

#define	REG_BG3CNT_SUB		0x400100E

#define	REG_BGOFFSETS_SUB	0x4001010

@ Background 0 horizontal scroll register (sub engine)
#define	REG_BG0HOFS_SUB		0x4001010
@ Background 0 vertical scroll register (sub engine)
#define	REG_BG0VOFS_SUB		0x4001012
@ Background 1 horizontal scroll register (sub engine)
#define	REG_BG1HOFS_SUB		0x4001014
@ Background 1 vertical scroll register (sub engine)
#define	REG_BG1VOFS_SUB		0x4001016
@ Background 2 horizontal scroll register (sub engine)
#define	REG_BG2HOFS_SUB		0x4001018
@ Background 2 vertical scroll register (sub engine)
#define	REG_BG2VOFS_SUB		0x400101A
@ Background 3 horizontal scroll register (sub engine)
#define	REG_BG3HOFS_SUB		0x400101C
@ Background 3 vertical scroll register (sub engine)
#define	REG_BG3VOFS_SUB		0x400101E

@ Background 2 Affine transform (sub engine)
#define	REG_BG2PA_SUB		0x4001020
@ Background 2 Affine transform (sub engine)
#define	REG_BG2PB_SUB		0x4001022
@ Background 2 Affine transform (sub engine)
#define	REG_BG2PC_SUB		0x4001024
@ Background 2 Affine transform (sub engine)
#define	REG_BG2PD_SUB		0x4001026

@ Background 2 Screen Offset (sub engine)
#define	REG_BG2X_SUB		0x4001028
@ Background 2 Screen Offset (sub engine)
#define	REG_BG2Y_SUB		0x400102C

@ Background 3 Affine transform (sub engine)
#define	REG_BG3PA_SUB		0x4001030
@ Background 3 Affine transform (sub engine)
#define	REG_BG3PB_SUB		0x4001032
@ Background 3 Affine transform (sub engine)
#define	REG_BG3PC_SUB		0x4001034
@ Background 3 Affine transform (sub engine)
#define	REG_BG3PD_SUB		0x4001036

@ Background 3 Screen Offset (sub engine)
#define	REG_BG3X_SUB		0x4001038
@ Background 3 Screen Offset (sub engine)
#define	REG_BG3Y_SUB		0x400103C
