//
//  MB_Notice.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/5.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_Notice.h"

@implementation MB_Notice

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"mid"] || [key isEqualToString:@"mtype"] || [key isEqualToString:@"fid"] ||[key isEqualToString:@"createTime"]) {
            [self setValue:@(0) forKey:key];
        }else {
            [self setValue:@"" forKey:key];
        }
        return;
    }
    
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"mid"]) {
        _mid = [value integerValue];
    }
    if ([key isEqualToString:@"mtype"]) {
        _mtype = [value integerValue];
    }
    if ([key isEqualToString:@"fid"]) {
        _fid = [value integerValue];
    }
    if ([key isEqualToString:@"createTime"]) {
        _createTime = [value integerValue];
    }
}

@end
