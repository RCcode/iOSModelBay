//
//  MB_LikeCollectViewCell.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/15.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_LikeCollectViewCell.h"

@implementation MB_LikeCollectViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCollect:(MB_Collect *)collect {
    _collect = collect;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:collect.fpic] placeholderImage:nil];
    _nameLabel.text = collect.fname;
}

@end
