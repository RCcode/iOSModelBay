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
            
            util.fName = @"";
            util.fGender = -1;
            util.fCareerId = @"";
            
            util.rGender = -1;
            util.rCareerId = @"";
    
            util.careerDic = @{@"1":@"bbb",
                               @"2":@"ccc",
                               @"3":@"ddd",
                               @"4":@"eee",
                               @"5":@"fff",
                               @"6":@"ggg",
                               @"7":@"ggg",
                               @"8":@"ggg",
                               @"9":@"ggg",
                               @"10":@"ggg",
                               @"11":@"ggg",
                               @"12":@"ggg",
                               @"13":@"ggg"};
        });
        
        util.eyeColor = @[@"Black", @"Blue", @"Brown", @"Green", @"Hazel", @"Other"];
        util.skincolor = @[@"Black", @"White", @"Olive", @"Tanned", @"Other"];
        util.haircolor = @[@"Black", @"Blonde", @"Brown", @"Grey", @"Red", @"Other"];
        util.shoesize = @[@"2", @"2.5", @"3", @"3.5", @"4", @"4.5", @"5", @"5.5", @"6", @"6.5", @"7", @"7.5", @"8", @"8.5", @"9", @"9.5", @"10", @"10.5", @"11", @"11.5", @"12", @"12.5", @"13", @"13.5", @"14", @"14.5"];
        
        
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

+ (void)showAlertViewWithMessage:(NSString *)string {
    if (string != nil && ![string isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

//+ (NSInteger)statFromResponse:(id)response {
//    NSInteger stat = [response[@"stat"] integerValue];
//    NSString *errorMsg = nil;
//    if (stat == 10001) {
//        errorMsg = @"参数异常";
//    }
//    if (stat == 10002) {
//        errorMsg = @"服务器异常";
//    }
//    if (stat == 10003) {
//        errorMsg = @"操作失败";
//    }
//    if (stat == 10004) {
//        errorMsg = @"无记录";
//    }
//    [MB_Utils showAlertViewWithMessage:errorMsg];
//    return stat;
//}

@end
