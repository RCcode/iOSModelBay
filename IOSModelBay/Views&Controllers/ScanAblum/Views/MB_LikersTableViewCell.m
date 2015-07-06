//
//  LikersTableViewCell.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/19.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_LikersTableViewCell.h"

@implementation MB_LikersTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _collectButton.layer.borderColor = [colorWithHexString(@"#ff4f42") colorWithAlphaComponent:0.9].CGColor;
    _collectButton.layer.borderWidth = 1;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
