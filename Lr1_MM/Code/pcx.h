/****************************************************************************\
**  Title:       PCX.H                                                      **
**  Purpose:     PCX/DCX Header file                                        **
**  Version:     1.0                                                        **
**  Date:        April 1991                                                 **
**  Author:      James D. Murray, Anaheim, CA, USA                          **
**  C Compilers: Borland C++ v2.0, Microsoft C v6.00a                       **
**                                                                          **
**  This file contains the header structures for the PCX and DCX image file **
**  formats.  Also included are the prototypes for the functions in the     **
**  source files PCXHEAD.C, DCXHEAD.C, PCXCODE.C, PCX2DCX.C, and DCX2PCX.C. **
**                                                                          **
**  Copyright (C) 1991 by Graphics Software Labs.  All rights reserved.     **
\****************************************************************************/
#ifndef _PCX_H
#define _PCX_H   1

#include "datatype.h"         /* Include data type definitions */
                                                               
/*
**  The PCX header format.
*/
typedef struct _PcxHeader       /* Offset   Description            */
{
    BYTE   Id;                  /*  00h     Manufacturer ID        */
    BYTE   Version;             /*  01h     Version                */
    BYTE   Format;              /*  02h     Encoding Scheme        */
    BYTE   BitsPixelPlane;      /*  03h     Bits/Pixel/Plane       */
    WORD   Xmin;                /*  04h     X Start (upper left)   */
    WORD   Ymin;                /*  06h     Y Start (top)          */
    WORD   Xmax;                /*  08h     X End (lower right)    */
    WORD   Ymax;                /*  0Ah     Y End (bottom)         */
    WORD   Hdpi;                /*  0Ch     Horizontal Resolution  */
    WORD   Vdpi;                /*  0Eh     Vertical Resolution    */
    BYTE   EgaPalette[48];      /*  10h     16-Color EGA Palette   */
    BYTE   Reserved;            /*  40h     Reserved               */
    BYTE   NumberOfPlanes;      /*  41h     Number of Color Planes */
    WORD   BytesLinePlane;      /*  42h     Bytes/Line/Plane       */
    WORD   PaletteInfo;         /*  44h     Palette Interpretation */
    WORD   HScreenSize;         /*  46h     Horizontal Screen Size */
    WORD   VScreenSize;         /*  48h     Vertical Screen Size   */
    BYTE   Filler[54];          /*  4Ah     Reserved               */
} PCXHEADER;

/*
**  PCX VGA palette.
*/
typedef struct _PcxVgaPalette
{
    BYTE   VgaPalette[768];     /*          256 VGA Color Palette  */
} PCXVGAPALETTE;

/*
**  The DCX header format.
*/
typedef struct _DcxHeader       /* Offset   Description            */
{
    DWORD   Id;                 /*   0h     File ID                */
    DWORD   PageList[1024];     /*   4h     Page List Array        */
} DCXHEADER;


/*
**  Function prototypes 
*/
SHORT PcxDecodeScanLine(BYTE *, WORD, FILE *);
WORD  PcxEncodeScanLine(BYTE *, BYTE *, WORD);
VOID  ReadPcxHeader(PCXHEADER *, FILE *);
VOID  WritePcxHeader(PCXHEADER *, FILE *);

#endif  /* _PCX_H */


