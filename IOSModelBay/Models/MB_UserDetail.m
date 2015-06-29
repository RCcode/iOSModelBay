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
        return;
    }
    [super setValue:value forUndefinedKey:key];
}

@end
