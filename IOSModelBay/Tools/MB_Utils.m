//
//  MB_Utils.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_Utils.h"

@implementation MB_Utils

+ (void)showPromptWithText:(NSString *)text{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:17.0];
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:0.8];
}


@end
