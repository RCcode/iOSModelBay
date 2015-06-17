//
//  MB_UserCollectViewCell.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_UserCollectViewCell.h"

@implementation MB_UserCollectViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

-(void)setUser:(MB_User *)user {
    [self layoutIfNeeded];
    _user = user;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:user.fpic] placeholderImage:nil];
    _usernameLabel.text = user.fname;
    
    //移除职业小图片
    for (UIView *subView in _careerView.subviews) {
        [subView removeFromSuperview];
    }
    
    if (![user.fcareerId isEqualToString:@""]) {
        //添加职业小图片
        NSArray *careers = [user.fcareerId componentsSeparatedByString:@"|"];
        CGFloat count = careers.count; //图片数量
        CGFloat space = 20;//相邻间隔
        CGFloat width = 25;//图片宽度和高度
        CGFloat leadingSpace = (_careerView.frame.size.width - space * (count - 1) - width * count) / 2;//与父视图的左右间隔;
        CGFloat topSpace = (_careerView.frame.size.height - width) / 2;//与父视图的上下间隔
        for (int i = 0; i < count; i ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(leadingSpace + i *(width + space), topSpace, width, width)];
            imageView.image = [UIImage imageNamed:@"b"];
            imageView.layer.cornerRadius = width / 2;
            imageView.layer.masksToBounds = YES;
            [_careerView addSubview:imageView];
        }
    }
}

@end
