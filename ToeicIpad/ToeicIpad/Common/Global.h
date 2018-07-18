//
//  Global.h
//  ToeicIpad
//
//  Created by DungLM3 on 7/18/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

#ifndef Global_h
#define Global_h

#import "Util.h"

#define NEW_VC(className) [[className alloc] initWithNibName :[Util getXIB:[className class]] bundle : nil]

/** Float: Portrait Screen Width **/
#define SCREEN_WIDTH   ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT   ([[UIScreen mainScreen] bounds].size.height)

#define kBaseURL_VOF   @"test"

#endif /* Global_h */

