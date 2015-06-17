//
//  MB_User.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/5.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_User.h"

@implementation MB_User

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"fid"]) {
        _fid = [value integerValue];
    }
    if ([key isEqualToString:@"fgender"]) {
        _fgender = [value integerValue];
    }
    if ([key isEqualToString:@"state"]) {
        _state = [value integerValue];
    }
}

@end
