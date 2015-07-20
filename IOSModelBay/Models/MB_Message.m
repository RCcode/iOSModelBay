//
//  MB_Message.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/24.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_Message.h"

@implementation MB_Message

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"ucid"] || [key isEqualToString:@"fid"] || [key isEqualToString:@"createTime"] ||[key isEqualToString:@"state"] || [key isEqualToString:@"id"] || [key isEqualToString:@"replyTime"] || [key isEqualToString:@"futype"] || [key isEqualToString:@"fstate"]) {
            [self setValue:@(0) forKey:key];
        }else {
            [self setValue:@"" forKey:key];
        }
        return;
    }
    
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"id"]) {
        _uid = [value integerValue];
    }
    if ([key isEqualToString:@"ucid"]) {
        _ucid = [value integerValue];
    }
    if ([key isEqualToString:@"fid"]) {
        _fid = [value integerValue];
    }
    if ([key isEqualToString:@"createTime"]) {
        _createTime = [value integerValue];
    }
    if ([key isEqualToString:@"state"]) {
        _state = [value integerValue];
    }
    if ([key isEqualToString:@"replyTime"]) {
        _replyTime = [value integerValue];
    }
}

@end
