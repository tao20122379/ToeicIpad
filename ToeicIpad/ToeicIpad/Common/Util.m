//
//  Util.m
//  ToeicIpad
//
//  Created by DungLM3 on 7/18/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (NSString *)getXIB:(Class)fromClass {
    NSString *className = NSStringFromClass(fromClass);
    return className;
}

+ (void)setObject:(id)obj forKey:(NSString *)key {
    if (obj) {
        [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (id)objectForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)setValue:(id)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
