//
//  MB_RankingTableViewCell.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/13.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_RankingTableViewCell.h"

@implementation MB_RankingTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _collectButton.layer.borderColor = [UIColor blackColor].CGColor;
    _collectButton.layer.borderWidth = 1;
    
    _ablumScrollView.pagingEnabled = NO;
}

- (void)setUser:(MB_User *)user {
    _user = user;
    
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:user.fpic] placeholderImage:nil];
    [_backImageView sd_setImageWithURL:[NSURL URLWithString:user.fbackPic] placeholderImage:nil];
    _usernameLabel.text = user.fname;
    _descLabel.text = @"";
    
    [self layoutIfNeeded];
    
    CGRect rect = _ablumScrollView.frame;
    NSLog(@"rect = %@",NSStringFromCGRect(rect));
    for (UIView *subView in _ablumScrollView.subviews) {
        [subView removeFromSuperview];
    }
    CGFloat imageWidth = kWindowWidth / 3;
    for (int i = 0; i < 5; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * (imageWidth+2.5), 0, imageWidth, rect.size.height)];
        imageView.image = [UIImage imageNamed:@"a"];
        imageView.userInteractionEnabled = YES;
        [_ablumScrollView addSubview:imageView];
    }
    _ablumScrollView.contentSize = CGSizeMake(5 * imageWidth +10, rect.size.height);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
