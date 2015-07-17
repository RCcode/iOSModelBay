//
//  MB_Ablum.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/5.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_Ablum.h"

@implementation MB_Ablum

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"ablId"] || [key isEqualToString:@"id"] || [key isEqualToString:@"atype"] ||[key isEqualToString:@"mId"] || [key isEqualToString:@"pId"] || [key isEqualToString:@"hId"] ||[key isEqualToString:@"mkId"] || [key isEqualToString:@"likes"] || [key isEqualToString:@"comments"]) {
            [self setValue:@(0) forKey:key];
        }else if ([key isEqualToString:@"mList"]) {
            [self setValue:@[] forKey:key];
        }else {
            [self setValue:@"" forKey:key];
        }
        return;
    }
    
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"ablId"]) {
        _ablId = [value integerValue];
    }
    if ([key isEqualToString:@"id"]) {
        _uid = [value integerValue];
    }
    if ([key isEqualToString:@"atype"]) {
        _atype = [value integerValue];
    }
    if ([key isEqualToString:@"mId"]) {
        _mkId = [value integerValue];
    }
    if ([key isEqualToString:@"pId"]) {
        _pId = [value integerValue];
    }
    if ([key isEqualToString:@"hId"]) {
        _hId = [value integerValue];
    }
    if ([key isEqualToString:@"mkId"]) {
        _mkId = [value integerValue];
    }
    if ([key isEqualToString:@"likes"]) {
        _likes = [value integerValue];
    }
    if ([key isEqualToString:@"comments"]) {
        _comments = [value integerValue];
    }
}

@end
