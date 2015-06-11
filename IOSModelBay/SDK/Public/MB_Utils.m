//
//  MB_Utils.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_Utils.h"

@implementation MB_Utils

static MB_Utils *util = nil;
+ (instancetype)shareUtil {
    if (util == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            util = [[MB_Utils alloc] init];
        });
    }
    return util;
}

+ (void)showPromptWithText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:17.0];
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:0.8];
}

@end
