//
//  MB_CustomButton.m
//  IOSModelBay
//
//  Created by lisongrc on 15/8/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_CustomButton.h"

@implementation MB_CustomButton

//解决自定义字体在button上显示不完全的问题
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.titleLabel.frame;
    frame.size.height = self.bounds.size.height - self.titleEdgeInsets.top - self.titleEdgeInsets.bottom;
    frame.origin.y = self.titleEdgeInsets.top;
    self.titleLabel.frame = frame;
}

@end
