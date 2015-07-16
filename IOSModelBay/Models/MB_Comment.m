//
//  MB_Comment.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/24.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_Comment.h"

@implementation MB_Comment

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"fid"] || [key isEqualToString:@"create_time"] || [key isEqualToString:@"utype"] || [key isEqualToString:@"state"]) {
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
    
    if ([key isEqualToString:@"create_time"]) {
        _create_time = [value integerValue];
    }
}

@end
