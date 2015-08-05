//
//  MB_UserInfoView.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/9.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_UserInfoView.h"

@implementation MB_UserInfoView

- (void)awakeFromNib {
    
    _likeButton.layer.borderWidth = 1;
    _likeButton.layer.borderColor = [colorWithHexString(@"#222222") colorWithAlphaComponent:0.9].CGColor;
}

@end
