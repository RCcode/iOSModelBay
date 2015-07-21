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
    
}

-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.coverView.backgroundColor = [colorWithHexString(@"#ff4f42") colorWithAlphaComponent:0.5];
        self.nameLabel.textColor = [UIColor whiteColor];
    }else{
        self.coverView.backgroundColor = [colorWithHexString(@"#ffffff") colorWithAlphaComponent:0.6];
        self.nameLabel.textColor = [UIColor blackColor];
    }
}

@end
