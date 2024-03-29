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
    
    _tap = [[UITapGestureRecognizer alloc] init];
    [_imagesScrollView addGestureRecognizer:_tap];
    
    _tap1 = [[UITapGestureRecognizer alloc] init];
    [_label1 addGestureRecognizer:_tap1];
    _tap2 = [[UITapGestureRecognizer alloc] init];
    [_label2 addGestureRecognizer:_tap2];
    _tap3 = [[UITapGestureRecognizer alloc] init];
    [_label3 addGestureRecognizer:_tap3];
    _tap4 = [[UITapGestureRecognizer alloc] init];
    [_label4 addGestureRecognizer:_tap4];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setAblum:(MB_Ablum *)ablum {
    _ablum = ablum;
    
    [self layoutIfNeeded];
    //添加影集的图片
    CGRect rect = _imagesScrollView.frame;
    
    for (UIView *subView in _imagesScrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    for (int i = 0; i < ablum.mList.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetHeight(rect) + 1) * i, 0, CGRectGetHeight(rect), CGRectGetHeight(rect))];
        NSString *imageName = [ablum.mList[i] objectForKey:@"url"];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:nil];
        imageView.backgroundColor = placeholderColor;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [_imagesScrollView addSubview:imageView];
    }
    _imagesScrollView.bounces = YES;
    _imagesScrollView.alwaysBounceHorizontal = YES;
    _imagesScrollView.contentSize = CGSizeMake(CGRectGetHeight(rect) * ablum.mList.count + 1 * (ablum.mList.count - 1), CGRectGetHeight(rect));
    _imagesScrollView.contentOffset = CGPointMake(0, 0);
    
    _nameLabel.text = ablum.name;
    _countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)ablum.mList.count];
    _descLabel.text = ablum.descr;
    _likeLabel.text = [NSString stringWithFormat:@"%ld",(long)ablum.likes];
    _commentLabel.text = [NSString stringWithFormat:@"%ld",(long)ablum.comments];
    
    NSString *str11 = LocalizedString(@"Model", nil);
    NSString *str12 = ablum.mName;
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",str11,str12]];
    [string1 addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"#ff4f42") range:NSMakeRange(str11.length + 1, str12.length)];
    
    NSString *str21 = LocalizedString(@"Photographer", nil);
    NSString *str22 = ablum.pName;
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",str21,str22]];
    [string2 addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"#ff4f42") range:NSMakeRange(str21.length + 1, str22.length)];
    
    NSString *str31 = LocalizedString(@"Hair Stylist", nil);
    NSString *str32 = ablum.hName;
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",str31,str32]];
    [string3 addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"#ff4f42") range:NSMakeRange(str31.length + 1, str32.length)];
    
    NSString *str41 = LocalizedString(@"Makeup Artist", nil);
    NSString *str42 = ablum.mkName;
    NSMutableAttributedString *string4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",str41,str42]];
    [string4 addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"#ff4f42") range:NSMakeRange(str41.length + 1, str42.length)];
    
    if ([ablum.mName isEqualToString:@""]) {
        _con1.constant = 7;
        _label1.text = ablum.mName;
    }else {
        _con1.constant = 12;
        _label1.attributedText = string1;
    }
    if ([ablum.pName isEqualToString:@""]) {
        _con2.constant = 0;
        _label2.text = ablum.pName;
    }else {
        _con2.constant = 5;
        _label2.attributedText = string2;
    }
    if ([ablum.hName isEqualToString:@""]) {
        _con3.constant = 0;
        _label3.text = ablum.hName;
    }else {
        _con3.constant = 5;
        _label3.attributedText = string3;
    }
    if ([ablum.mkName isEqualToString:@""]) {
        _con4.constant = 0;
        _label4.text = ablum.mkName;
    }else {
        _con4.constant = 5;
        _label4.attributedText = string4;
    }
}

//
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    NSLog(@"asas");
//    if (CGRectContainsPoint(_imagesScrollView.frame, point)) {
//        return self;
//    }else {
//        return [super hitTest:point withEvent:event];
//    }
//}

@end
