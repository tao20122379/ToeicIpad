//
//  Util.h
//  ToeicIpad
//
//  Created by DungLM3 on 7/18/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+ (NSString *)getXIB:(Class)fromClass;
+ (void)setObject:(id)obj forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;
+ (void)setValue:(id)value forKey:(NSString *)key;


@end
