//
//  MB_User.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/5.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_User.h"

@implementation MB_User

- (instancetype)init {
    self =  [super init];
    if (self) {
        _likeType = LikedTypeNone;
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"fid"] || [key isEqualToString:@"uid"] || [key isEqualToString:@"fgender"] ||[key isEqualToString:@"state"] ||[key isEqualToString:@"liked"]) {
            [self setValue:@(0) forKey:key];
        }else {
            [self setValue:@"" forKey:key];
        }
        return;
    }
    
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"fid"]) {
        _fid = [value integerValue];
    }
    if ([key isEqualToString:@"uid"]) {
        _uid = [value integerValue];
    }
    if ([key isEqualToString:@"fgender"]) {
        _fgender = [value integerValue];
    }
    if ([key isEqualToString:@"state"]) {
        _state = [value integerValue];
    }
    if ([key isEqualToString:@"liked"]) {
        _liked = [value integerValue];
    }
}

@end
