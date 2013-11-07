//
//  Defines.h
//  Lr1_MM
//
//  Created by Max Kuznetsov on 22.10.13.
//  Copyright (c) 2013 111Minutes. All rights reserved.
//

// convert dword to uiinteger. firstByte - second byte in dword, secondByte - first byte in dword
NSUInteger UIIntegerFromBytes(Byte firstByte, Byte secondByte);
NSUInteger RoundFloat(CGFloat floatValue);

//#define DEBUG_MOD

#define RGBA(red, green, blue, alpha) [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:alpha]
#define WA(white, alpha) [UIColor colorWithWhite:white / 255.0f alpha:alpha];