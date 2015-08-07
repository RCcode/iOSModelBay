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
//    self.layoutMargins = UIEdgeInsetsZero;
    
//    _mylayer = [CAShapeLayer layer];
//    _mylayer.lineWidth = 1;
//    _mylayer.lineDashPhase = 5;
//    _mylayer.lineDashPattern = @[@(5)];
//    _mylayer.strokeColor = [UIColor redColor].CGColor;
//    _mylayer.fillColor = [UIColor clearColor].CGColor;
//    self.clipsToBounds = YES;
//    [self.layer addSublayer:_mylayer];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
//    CGRect rect = self.bounds;
//    rect.size.height += 10;
//    _mylayer.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
