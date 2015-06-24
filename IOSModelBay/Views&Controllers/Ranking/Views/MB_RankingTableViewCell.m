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

}

- (void)setUser:(MB_User *)user {
    _user = user;
    
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:user.fpic] placeholderImage:nil];
    [_backImageView sd_setImageWithURL:[NSURL URLWithString:user.fbackPic] placeholderImage:nil];
    _rankImageView.image = [UIImage imageNamed:@"a"];
    _usernameLabel.text = user.fname;
    _descLabel.text = @"";
    
    CGRect rect = self.ablumScrollView.frame;
    for (UIView *subView in self.ablumScrollView.subviews) {
        [subView removeFromSuperview];
    }
    CGFloat imageWidth = kWindowWidth / 3;
    for (int i = 0; i < 5; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * (imageWidth+2.5), 0, imageWidth, rect.size.height)];
        imageView.image = [UIImage imageNamed:@"a"];
        imageView.userInteractionEnabled = YES;
        [self.ablumScrollView addSubview:imageView];
    }
    self.ablumScrollView.pagingEnabled = NO;
    self.ablumScrollView.contentSize = CGSizeMake(5 * imageWidth +10, rect.size.height);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
