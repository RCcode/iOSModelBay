//
//  MB_UserDetail.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/24.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_UserDetail.h"

@implementation MB_UserDetail

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"id"] || [key isEqualToString:@"state"] || [key isEqualToString:@"height"] || [key isEqualToString:@"weight"] ||[key isEqualToString:@"chest"] ||[key isEqualToString:@"waist"] ||[key isEqualToString:@"hips"]||[key isEqualToString:@"age"] ||[key isEqualToString:@"gender"] || [key isEqualToString:@"btype"] || [key isEqualToString:@"ctype"] || [key isEqualToString:@"etype"]) {
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
    if ([key isEqualToString:@"state"]) {
        _state = [value integerValue];
    }
    if ([key isEqualToString:@"gender"]) {
        _gender = [value integerValue];
    }
    if ([key isEqualToString:@"age"]) {
        _age = [value integerValue];
    }
    if ([key isEqualToString:@"height"]) {
        _height = [value integerValue];
    }
    if ([key isEqualToString:@"weight"]) {
        _weight = [value integerValue];
    }
    if ([key isEqualToString:@"chest"]) {
        _chest = [value integerValue];
    }
    if ([key isEqualToString:@"waist"]) {
        _waist = [value integerValue];
    }
    if ([key isEqualToString:@"hips"]) {
        _hips = [value integerValue];
    }
    if ([key isEqualToString:@"btype"]) {
        _btype = [value integerValue];
    }
    if ([key isEqualToString:@"ctype"]) {
        _ctype = [value integerValue];
    }
    if ([key isEqualToString:@"etype"]) {
        _etype = [value integerValue];
    }
}

@end
