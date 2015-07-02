//
//  MB_SummaryTableViewCell.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/11.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_SummaryTableViewCell.h"

@implementation MB_SummaryTableViewCell

- (void)awakeFromNib {
    // Initialization code    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
//    _mylayer = [CAShapeLayer layer];
//    CGRect rect = self.contentView.bounds;
//    rect.size.height += 10;
//    _mylayer.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
//    _mylayer.frame = CGRectMake(0, 0, kWindowWidth, rect.size.height);
//    _mylayer.lineWidth = 2;
//    _mylayer.lineDashPhase = 5;
//    _mylayer.lineDashPattern = @[@(5)];
//    _mylayer.strokeColor = [UIColor redColor].CGColor;
//    _mylayer.fillColor = [UIColor clearColor].CGColor;
//    
//    self.contentView.clipsToBounds = YES;
//    [self.contentView.layer addSublayer:_mylayer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
