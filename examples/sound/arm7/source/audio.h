#define BIT(n) (1<<(n))

#define SOUND_VOL(n)	(n)
#define SOUND_FREQ(n)	((-0x1000000 / (n)))
#define SOUND_ENABLE	BIT(15)
#define SOUND_REPEAT    BIT(27)
#define SOUND_ONE_SHOT  BIT(28)
#define SOUND_16BIT     BIT(29)
#define SOUND_8BIT      (0)

#define SOUND_BUSY		BIT(31)

#define SOUND_PAN(n)	((n) << 16)

#define SCHANNEL_ENABLE BIT(31)

@ registers
@ 32-bit
#define SCHANNEL_CR(n)				(0x04000400 + ((n)<<4))
@ 8-bit
#define SCHANNEL_VOL(n)				(0x04000400 + ((n)<<4))
#define SCHANNEL_PAN(n)				(0x04000402 + ((n)<<4))
@ 32-bit
#define SCHANNEL_SOURCE(n)			(0x04000404 + ((n)<<4))
@ 16-bit
#define SCHANNEL_TIMER(n)			(0x04000408 + ((n)<<4))
#define SCHANNEL_REPEAT_POINT(n)	(0x0400040A + ((n)<<4))
@ 32-bit
#define SCHANNEL_LENGTH(n)			(0x0400040C + ((n)<<4))

@ 16-bit
#define SOUND_CR          0x04000500
@ 8-bit
#define SOUND_MASTER_VOL  0x04000500
@ not sure on the following
@ 16-bit
#define SOUND_BIAS        0x04000504
#define SOUND508          0x04000508
#define SOUND510          0x04000510
#define SOUND514		  0x04000514
#define SOUND518          0x04000518
#define SOUND51C          0x0400051C
