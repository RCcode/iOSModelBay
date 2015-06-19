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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.ablumScrollView.frame;
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
