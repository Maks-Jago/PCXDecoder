/****************************************************************************\
**  Title:   DATATYPE.H                                                     **
**  Purpose: Special data types used in source code.                        **
**  Version: 1.0.0                                                          **
**  Date:    April 1991                                                     **
**  Author:  James D. Murray, Anaheim, CA  USA                              **
**                                                                          **
**  Data type definitions and directives use to consolidate the             **
**  data types used in the source modules and to ease the job of            **
**  porting code to other systems.                                          **
**                                                                          **
**  Copyright (C) 1991 by Graphics Software Labs.  All rights reserved.     **
\****************************************************************************/
#if !defined(DATATYPE_H)
#define DATATYPE_H      1           /* Used to prevent recursive inclusion */

#include <stddef.h>                 /* Standard ANSI definitions  */
#include <limits.h>

#define FALSE           0           /* FALSE boolean data value   */
#define TRUE            !FALSE      /* TRUE boolean data value    */

/*
**  Data type definitions.  Used to aid in portability and to make
**  source code generally more readable.
*/
typedef void            VOID;       /* Void data type             */
typedef signed char     CHAR;       /*  8-bit signed data type    */
typedef unsigned char   BYTE;       /*  8-bit unsigned data type  */
typedef signed short    SHORT;      /* 16-bit signed data type    */
typedef unsigned short  WORD;       /* 16-bit unsigned data type  */
typedef signed long     LONG;       /* 32-bit signed data type    */
typedef unsigned long   DWORD;      /* 32-bit unsigned data type  */
                
/*
**  A variety of macros used to tear down and build up words of data.
*/
#define LOBYTE(w)       ((BYTE) (w))
#define HIBYTE(w)       ((BYTE) ((0x00FF & (WORD) ((w) >>  8))))
#define LOWORD(d)       ((WORD) (d))
#define HIWORD(d)       ((WORD) ((0xFFFF & (DWORD)((d) >> 16))))
#define MAKEWORD(h,l)   (((WORD)  ((WORD)  (h) <<  8)) | (WORD) ((BYTE) (l)))
#define MAKEDWORD(h,l)  (((DWORD) ((DWORD) (h) << 16)) | (DWORD)((WORD) (l)))

/*
**  A variety of macros used to test/flip bits within words of data.
*/
/* Flip the specified bit to 0 */
#define BITCLEAR(field, bit)  ((field) & ~(bit))
/* Flip the specified bit to 1 */
#define BITSET(field, bit)    ((field) | (bit))
/* Flip the specified bit to its inverse state */
#define BITTOG(field, bit)    ((field) ^ (bit))
/* Create a string of 0 bits from n to m */
#define BITSON(n, m)          (~(~0 << (m) << 0) & (~0 << (n)))
/* Create a string of 1 bits from n to m */
#define BITSOFF(n, m)         (~(~0 << (m) << 1) & (~0 << (n)))


/* Structure copy macro */
#if defined(__STDC__)
#define assignstruct(a, b)  ((a) = (b))
#else
#define assignstruct(a, b)  (memcpy((char*)&(a), (char *)&(b), sizeof(a)))
#endif

#if !defined(offsetof)
#define offsetof(s, m)  ((size_t)&(((s *)0)->m))
#endif

#if !defined(max)
#define max(a,b)        (((a) > (b)) ? (a) : (b))
#endif

#if !defined(min)
#define min(a,b)        (((a) < (b)) ? (a) : (b))
#endif

#endif  /* DATATYPE_H */

