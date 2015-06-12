//
//  MB_FilterCollectViewCell.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/9.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_FilterCollectViewCell.h"

@implementation MB_FilterCollectViewCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.nameLabel.textColor = [UIColor redColor];
    }else{
        self.nameLabel.textColor = [UIColor blackColor];
    }
}

@end
