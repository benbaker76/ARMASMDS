
//{{BLOCK(pic)

//======================================================================
//
//	pic, 256x192@8, 
//	Transparent color : 00,00,00
//	+ palette 256 entries, not compressed
//	+ 648 tiles (t|f|p reduced) not compressed
//	+ regular map (flat), not compressed, 32x24 
//	Total size: 512 + 41472 + 1536 = 43520
//
//	Time-stamp: 2010-01-07, 04:37:33
//	Exported by Cearn's GBA Image Transmogrifier, v0.8.3
//	( http://www.coranac.com/projects/#grit )
//
//======================================================================

#ifndef GRIT_PIC_H
#define GRIT_PIC_H

#define picTilesLen 41472
extern const unsigned int picTiles[10368];

#define picMapLen 1536
extern const unsigned short picMap[768];

#define picPalLen 512
extern const unsigned short picPal[256];

#endif // GRIT_PIC_H

//}}BLOCK(pic)
