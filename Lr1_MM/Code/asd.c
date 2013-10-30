/****************************************************************************\
**  Title:       PCXDECODE.C                                                **
**  Purpose:     Decode a PCX image file scan line.                         **
**  Version:     1.0                                                        **
**  Date:        May 1991                                                   **
**  Author:      James D. Murray, Anaheim, CA  USA                          **
**  C Compilers: Borland C++ v2.0, Microsoft C v6.00a                       **
**                                                                          **
**  Decode an image scan line using the PCX run-length encoding algorithm   **
**  Decoded data is returned in a buffer.  Useful for algorithms that need  **
**  to work on images one scan line at a time.                              **
**                                                                          **
**  This module contains the following functions:                           **
**                                                                          **
**      PcxDecodeScanLine - Decode a PCX RLE-encoded scan line              **
**                                                                          **
**  Copyright (C) 1991 by Graphics Software Labs.  All rights reserved.     **
\****************************************************************************/
#include <stdio.h>
#include "endianio.h"
#include "pcx.h"


/*
**  Decode (uncompress) a PCX image file scan line.
**
**  PcxDecodeScanLine() decodes a buffer containing scan line data encoded
**  using the PCX run-length encoding algorithm.  The encoded data is read
**  from a FILE stream, decoded, and then written to a pointer to a buffer
**  passed to this function.
**
**  The PCX specification states (in so many words) that the run-length
**  encoding of a pixel run should stop at the end of each scan line. 
**  However, some PCX encoders may continue the encoding of a pixel run on
**  to the beginning of the next scan line, if possible.  This code,
**  therefore, assumes that any pixel run can span scan lines.
**
**  To check for decoding errors, the value returned by PcxDecodeScanLine()
**  should be the same as the value of BufferSize (the length of an
**  uncompressed scan line).
**
**  Returns: Total number of pixels decoded from compressed scan line,
**           or EOF if a file stream error occured.
*/
SHORT
PcxDecodeScanLine(DecodedBuffer, BufferSize, FpPcx)
BYTE *DecodedBuffer;    /* Pointer to buffer to hold decoded data         */
WORD  BufferSize;       /* Size of buffer to hold decoded data            */
FILE *FpPcx;            /* FILE pointer to the open input PCX image file  */
{
    WORD  index = 0;            /* Index into compressed scan line buffer */
    SHORT total = 0;            /* Running total of decoded pixel values  */
    BYTE  byte;                 /* Data byte read from PCX file           */
    static BYTE runcount = 0;   /* Length of decoded pixel run            */
    static BYTE runvalue = 0;   /* Value of decoded pixel run             */

    /*
    ** If there is any data left over from the previous scan
    ** line write it to the beginning of this scan line.
    */
    do
    {
        /* Write the pixel run to the buffer */
        for (total += runcount;                 /* Update total             */
             runcount && index < BufferSize;    /* Don't read past buffer   */
             runcount--, index++)
            DecodedBuffer[index] = runvalue;    /* Assign value to buffer   */

        if (runcount)           /* Encoded run ran past end of scan line    */
        {
            total -= runcount;  /* Subtract count not written to buffer     */
            return(total);      /* Return number of pixels decoded          */
        }

        /*
        ** Get the next encoded run packet.
        **
        ** Read a byte of data.  If the two MBSs are 1 then this byte
        ** holds a count value (0 to 63) and the following byte is the
        ** data value to be repeated.  If the two MSBs are 0 then the
        ** count is one and the byte is the data value itself.
        */
        byte = GetByte(FpPcx);                  /* Get next byte    */

        if ((byte & 0xC0) == 0xC0)              /* Two-byte code    */
        {
            runcount = byte & 0x3F;             /* Get run count    */
            runvalue = GetByte(FpPcx);          /* Get pixel value  */
        }
        else                                    /* One byte code    */
        {
            runcount = 1;                       /* Run count is one */
            runvalue = byte;                    /* Pixel value      */
        }
    }
    while (index < BufferSize);     /* Read until the end of the buffer     */

    if (ferror(FpPcx))
        return(EOF);    /* File stream error.  Probably a premature EOF     */

    return(total);      /* Return number of pixels decoded                  */
}

