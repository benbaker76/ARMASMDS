#define BIT(n) (1<<(n))

@ LCD status register.
#define	REG_DISPSTAT		0x04000004

#define DISP_IN_VBLANK		BIT(0)
#define DISP_IN_HBLANK		BIT(1)
#define DISP_YTRIGGERED		BIT(2)
#define DISP_VBLANK_IRQ		BIT(3)
#define DISP_HBLANK_IRQ		BIT(4)
#define DISP_YTRIGGER_IRQ	BIT(5)

@ Current display scanline.
#define	REG_VCOUNT			0x4000006

@ Halt control register.
@ Writing 0x40 to HALT_CR activates GBA mode.
@ HALT_CR can only be accessed via the BIOS.
#define HALT_CR				0x04000300

@ Power control register.
@ This register controls what hardware should
@ be turned on or off.
#define	REG_POWERCNT		0x4000304

#define POWER_SOUND       	BIT(0)
#define POWER_UNKNOWN     	BIT(1)

@ Key input register.
@ On the ARM9, the hinge "button", the touch status, and the
@ X and Y buttons cannot be accessed directly.

#define	REG_KEYINPUT		0x04000130

@ Key input control register.
#define	REG_KEYCNT			0x04000132

@ Default location for the user's personal data (see %PERSONAL_DATA).
#define PersonalData		0x27FFC80

#define KEY_A          BIT(0)
#define KEY_B          BIT(1)
#define KEY_SELECT     BIT(2)
#define KEY_START      BIT(3)
#define KEY_RIGHT      BIT(4)
#define KEY_LEFT       BIT(5)
#define KEY_UP         BIT(6)
#define KEY_DOWN       BIT(7)
#define KEY_R          BIT(8)
#define KEY_L          BIT(9)
