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
    
    for (NSString *fa in [UIFont familyNames]) {
        for (NSString *name in [UIFont fontNamesForFamilyName:fa]) {
            NSLog(@"%@",name);
        }
    }
    
    _inviteButton.layer.borderWidth = 1;
    _inviteButton.layer.borderColor = [colorWithHexString(@"#222222") colorWithAlphaComponent:0.9].CGColor;
    
    _likeButton.layer.borderWidth = 1;
    _likeButton.layer.borderColor = [colorWithHexString(@"#222222") colorWithAlphaComponent:0.9].CGColor;
}

@end
