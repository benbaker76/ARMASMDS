#define IPC					0x027FF000

@ 32-bit
#define IPC_SOUND_DATA(n)	(((n) * 0xF) + IPC)
@ 32-bit
#define IPC_SOUND_LEN(n)	(((n) * 0xF) + IPC_SOUND_DATA(n) + 4)
@ 32-bit
#define IPC_SOUND_RATE(n)	(((n) * 0xF) + IPC_SOUND_LEN(n) + 4)
@ 8-bit
#define IPC_SOUND_VOL(n)	(((n) * 0xF) + IPC_SOUND_RATE(n) + 1)
#define IPC_SOUND_PAN(n)	(((n) * 0xF) + IPC_SOUND_VOL(n) + 1)
#define IPC_SOUND_FORMAT(n)	(((n) * 0xF) + IPC_SOUND_PAN(n) + 1)
