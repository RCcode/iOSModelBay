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
    [super setValue:value forKey:key];
    
    //    if ([key isEqualToString:@"id"]) {
    //        _media_id = value;
    //    }
    //
    //    if ([key isEqualToString:@"caption"]) {
    //        _desc = value[@"text"];
    //    }
    //
    //    if ([key isEqualToString:@"user"]) {
    //        _username = value[@"username"];
    //        _uid = value[@"id"];
    //        _profile_picture = value[@"profile_picture"];
    //    }
    //
    //    if ([key isEqualToString:@"likes"]) {
    //        _likes = value[@"count"];
    //    }
}

@end