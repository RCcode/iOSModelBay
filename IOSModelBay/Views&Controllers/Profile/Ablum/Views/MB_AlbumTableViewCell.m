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
}

- (void)setAblum:(MB_Ablum *)ablum {
    _ablum = ablum;
    
    [self layoutIfNeeded];
    //添加影集的图片
    CGRect rect = _imagesScrollView.frame;
    
    [_imagesScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < ablum.mList.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetHeight(rect) + 1) * i, 0, CGRectGetHeight(rect), CGRectGetHeight(rect))];
        NSString *imageName = [ablum.mList[i] objectForKey:@"url"];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:nil];
        imageView.backgroundColor = placeholderColor;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
//        imageView.clipsToBounds = YES;
        [_imagesScrollView addSubview:imageView];
    }
    _imagesScrollView.bounces = YES;
    _imagesScrollView.alwaysBounceHorizontal = YES;
    _imagesScrollView.delaysContentTouches = NO;
    _imagesScrollView.contentSize = CGSizeMake(CGRectGetHeight(rect) * ablum.mList.count + 1 * (ablum.mList.count - 1), CGRectGetHeight(rect));
    
    _nameLabel.text = ablum.name;
    _countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)ablum.mList.count];
    _descLabel.text = ablum.descr;
    
    _label1.text = ablum.mName;
    _label2.text = ablum.pName;
    _label3.text = ablum.hName;
    _label4.text = ablum.mkName;
//    if ([ablum.mName isEqualToString:@""]) {
//        _con1.constant = 0;
//    }else {
//        _con1.constant = 5;
//    }
    if ([ablum.pName isEqualToString:@""]) {
        _con2.constant = 0;
    }else {
        _con2.constant = 5;
    }
    if ([ablum.hName isEqualToString:@""]) {
        _con3.constant = 0;
    }else {
        _con3.constant = 5;
    }
    if ([ablum.mkName isEqualToString:@""]) {
        _con4.constant = 5;
    }else {
        _con4.constant = 0;
    }
}

@end
