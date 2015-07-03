//
//  MB_AlbumTableViewCell.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_AlbumTableViewCell.h"

@implementation MB_AlbumTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
//    _hub = [[RKNotificationHub alloc] initWithView:self.contentView];
//    [_hub moveCircleByX:20 Y:20]; // moves the circle five pixels left and 5 down
//    [_hub increment];
//    //    [hub hideCount]; // uncomment for a blank badge
//    [_hub pop];//缩放
//    //    [hub blink];//闪烁
//    //    [hub bump];//跳跃
//    [_hub scaleCircleSizeBy:1.0];//缩放大小
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAblum:(MB_Ablum *)ablum {
    _ablum = ablum;
    
    [self layoutIfNeeded];
    CGRect rect = _imagesScrollView.frame;
    for (int i = 0; i < 5; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetHeight(rect) + 1) * i, 0, CGRectGetHeight(rect), CGRectGetHeight(rect))];
        imageView.image = [UIImage imageNamed:@"a"];
        imageView.backgroundColor = [UIColor greenColor];
        [_imagesScrollView addSubview:imageView];
    }
    _imagesScrollView.bounces = YES;
    _imagesScrollView.alwaysBounceHorizontal = YES;
    _imagesScrollView.contentSize = CGSizeMake(CGRectGetHeight(rect) * 5 + 1 * 4, CGRectGetHeight(rect));
}

@end
