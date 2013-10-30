/****************************************************************************\
**  Title:        ENDIANIO                                                  **
**  Purpose:      I/O functions to read data in either byte-order.          **
**  Version:      1.0.0                                                     **
**  Date:         May 1991                                                  **
**  Author:       James D. Murray, Anaheim, CA, USA                         **
**  C Compilers:  Borland C++ v2.0, Microsoft C v6.00a                      **
**                                                                          **
**  The functions in this module are used to read and write 16 and          **
**  32-bit data words in the big-endian (Motorola) and little-endian        **
**  (Intel) format.  These function are used primarily to read data         **
**  files that are not of the native byte-order of the machine they         **
**  are residing on (for example, reading a big-endian Macintosh            **
**  file that is stored on a little-endian IBM PC).                         **
**                                                                          **
**  Any module using these endian I/O function must include the file        **
**  ENDIANIO.H for the appropriate define directives and function           **
**  prototypes.                                                             **
**                                                                          **
**  Refer to the article "Which Endian Is Up?" by James D. Murray           **
**  in the C Gazette, Summer 1990 issue (Volume 4, Number 4) for            **
**  more information on data "endianness."                                  **
**                                                                          **
**  Copyright (C) 1991 by James D. Murray.  All rights reserved.            **
\****************************************************************************/
#include <stdio.h>
#include "endianio.h"

/*
**  Global function pointers to endian I/O functions.
**
**  Any source code module (file) using the endian I/O functions
**  found in this module (ENDIANIO.C) should declare the following
**  global pointers to functions to be extrnal and then assign the
**  appropriate big or little-endian I/O function to the pointer.
**  All function calls would then be made via the pointer rather
**  than by directly calling the function.  Example:
**
**      #include "endianio.h"
**
**      extern DWORD (*GetDword)(FILE *);
**      DWORD word;
**
**      GetDword = GetBigDword;
**
**      dword = GetDword(FilePointer);  / * Get a 32-bit, big-endian word * /
*/
extern WORD  (*GetWord)(FILE *);
extern DWORD (*GetDword)(FILE *);
extern VOID  (*PutWord)(WORD, FILE *);
extern VOID  (*PutDword)(DWORD, FILE *);


/*
**  Return the native byte-order of a machine.
**
**  This function will indicate the byte-order of the machine it is
**  being executed on.  A 2-byte word is assigned a value that sets one
**  byte to zero and the other byte to one.  The low byte is examined
**  and if it is zero then the machine is big-endian.  If the low byte
**  is one then the machine is little-endian.
**  
**  Paramenters: None.
**
**  Returns: ENDIAN_LSB if the native byte-order is little-endian, otherwise
**           ENDIAN_MSB if the native byte-order is big-endian.
*/
WORD TestByteOrder(VOID)
{
    WORD  word = 0x0001;
    BYTE *byte = (BYTE *) &word;

    return(byte[0] ? ENDIAN_LSB : ENDIAN_MSB);
}


/*
**  Read a 16-bit word in big-endian order.
**
**  Parameters: FilePtr - Pointer to file stream reading data from.
**
**  Returns: A 16-bit word in big-endian order.
*/
WORD GetBigWord(FILE *FilePtr)
{
    register WORD word;

    word =  (WORD) (fgetc(FilePtr) & 0xff);
    word = ((WORD) (fgetc(FilePtr) & 0xff)) | (word << 0x08);

    return(word);
}


/*
**  Read a 16-bit word in little-endian order.
**
**  Parameters: FilePtr - Pointer to file stream reading data from.
**
**  Returns: A 16-bit word in little-endian order.
*/
WORD GetLittleWord(FILE *FilePtr)
{
    register WORD word;

    word  =   (WORD) (fgetc(FilePtr) & 0xff);
    word |= (((WORD) (fgetc(FilePtr) & 0xff)) << 0x08);

    return(word);
}


/*
**  Write a 16-bit word in big-endian order.
**
**  Parameters: Word    - Data word to write.
**              FilePtr - Pointer to file stream writing data to.
**
**  Returns: Nothing.
*/
VOID PutBigWord(WORD Word, FILE *FilePtr)
{
    fputc((Word >> 0x08) & 0xff, FilePtr);
    fputc(Word & 0xff, FilePtr);
}


/*
**  Write a 16-bit word in little-endian order.
**
**  Parameters: Word    - Data word to write.
**              FilePtr - Pointer to file stream writing data to.
**
**  Returns: Nothing.
*/
VOID PutLittleWord(WORD Word, FILE *FilePtr)
{
    fputc(Word & 0xff, FilePtr);
    fputc((Word >> 0x08) & 0xff, FilePtr);
}


/*
**  Read a 32-bit word in big-endian order.
**
**  Parameters: FilePtr - Pointer to file stream reading data from.
**
**  Returns: A 32-bit word in big-endian order.
*/
DWORD GetBigDword(FILE *FilePtr)
{
    register DWORD word;

    word =  (DWORD) (fgetc(FilePtr) & 0xff);
    word = ((DWORD) (fgetc(FilePtr) & 0xff)) | (word << 0x08);
    word = ((DWORD) (fgetc(FilePtr) & 0xff)) | (word << 0x08);
    word = ((DWORD) (fgetc(FilePtr) & 0xff)) | (word << 0x08);

    return(word);
}


/*
**  Read a 32-bit word in little-endian order.
**
**  Parameters: FilePtr - Pointer to file stream reading data from.
**
**  Returns: A 32-bit word in little-endian order.
*/
DWORD GetLittleDword(FILE *FilePtr)
{
    register DWORD word;

    word  =   (DWORD) (fgetc(FilePtr) & 0xff);
    word |= (((DWORD) (fgetc(FilePtr) & 0xff)) << 0x08);
    word |= (((DWORD) (fgetc(FilePtr) & 0xff)) << 0x10);
    word |= (((DWORD) (fgetc(FilePtr) & 0xff)) << 0x18);

    return(word);
}


/*
**  Write a 32-bit word in big-endian order.
**
**  Parameters: Word    - Data word to write.
**              FilePtr - Pointer to file stream writing data to.
**
**  Returns: Nothing.
*/
VOID PutBigDword(DWORD Word, FILE *FilePtr)
{
    fputc((WORD) (Word >> 0x18) & 0xff, FilePtr);
    fputc((WORD) (Word >> 0x10) & 0xff, FilePtr);
    fputc((WORD) (Word >> 0x08) & 0xff, FilePtr);
    fputc((WORD) Word & 0xff, FilePtr);
}


/*
**  Write a 32-bit word in little-endian order.
**
**  Parameters: Word    - Data word to write.
**              FilePtr - Pointer to file stream writing data to.
**
**  Returns: Nothing.
*/
VOID PutLittleDword(DWORD Word, FILE *FilePtr)
{
    fputc((WORD) Word & 0xff, FilePtr);
    fputc((WORD) (Word >> 0x08) & 0xff, FilePtr);
    fputc((WORD) (Word >> 0x10) & 0xff, FilePtr);
    fputc((WORD) (Word >> 0x18) & 0xff, FilePtr);
}


/*
**  Read a string of characters from a file stream.
**
**  A string of characters is read from the file stream Fp
**  and written to the buffer String.  The number of characters
**  read is equal to the value of NumChars and no NULL is
**  appended to the string.
**
**  Parameters: String   - Pointer to a buffer to hold string read
**              NumChars - Number of characters to read into buffer
**              Fp       - Pointer to file stream to read
**
**  Returns: A pointer to the string read, otherwise NULL if EOF
**           was encountered before all characters were read or
**           a file stream error occured.
*/
BYTE *GetString(BYTE *String, WORD NumChars, FILE *Fp)
{
	register BYTE  *ptr;
	register int   i = 0;

	for (ptr = String; NumChars > 0 && (i = fgetc(Fp)) != EOF; NumChars--, ptr++)
        *ptr = (BYTE) i;

	if (i == EOF && ptr == String)
        return(NULL);

	return(ferror(Fp) ? NULL : String);
}

/*
**  Write a string of characters to a file stream.
**
**  A string of characters is read from the buffer String and
**  written to the file stream Fp.  The number of characters
**  written is equal to the value of NumChars.
**
**  Parameters: String   - Pointer to a buffer holding string to write
**              NumChars - Number of characters to write into file stream
**              Fp       - Pointer to file stream to write
**
**  Returns: A pointer to the last character written, otherwise NULL
**           if a file stream error occured.
*/
BYTE *PutString(BYTE *String, WORD NumChars, FILE *Fp)
{
	register BYTE  *ptr;

	for (ptr = String; NumChars > 0; NumChars--, ptr++)
        fputc(*ptr, Fp);

	return(ferror(Fp) ? NULL : ptr);
}

