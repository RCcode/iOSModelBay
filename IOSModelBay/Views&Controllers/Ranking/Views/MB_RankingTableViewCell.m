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
    
    _ablumScrollView.pagingEnabled = NO;
}

- (void)setUser:(MB_User *)user {
    _user = user;
    
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:user.fpic] placeholderImage:nil];
    [_backImageView sd_setImageWithURL:[NSURL URLWithString:user.fbackPic] placeholderImage:nil];
    _usernameLabel.text = user.fname.uppercaseString;
    
    NSMutableArray *careerArr = [NSMutableArray arrayWithCapacity:0];
    for (NSString *career in [_user.fcareerId componentsSeparatedByString:@"|"]) {
        [careerArr addObject:[[MB_Utils shareUtil].careerDic objectForKey:career]?:@""];
    }
    _descLabel.text = [careerArr componentsJoinedByString:@"  |  "];
    
    if (![userDefaults boolForKey:kIsLogin]) {
        _sanjiaoImageView.hidden = YES;
    }else {
        _sanjiaoImageView.hidden = NO;
    }
    
    [self layoutIfNeeded];
    
    CGRect rect = _ablumScrollView.frame;
    for (UIView *subView in _ablumScrollView.subviews) {
        [subView removeFromSuperview];
    }
    CGFloat imageWidth = 90;
    for (int i = 0; i < user.urlArray.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2 + i * (imageWidth+2), 2, imageWidth, rect.size.height - 2)];
        imageView.backgroundColor = placeholderColor;
        [imageView sd_setImageWithURL:[NSURL URLWithString:user.urlArray[i]] placeholderImage:nil];
        imageView.userInteractionEnabled = YES;
        [_ablumScrollView addSubview:imageView];
    }
    _ablumScrollView.contentSize = CGSizeMake(user.urlArray.count * (imageWidth + 2) + 4, 0);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
