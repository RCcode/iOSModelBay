//
//  MB_selectPhotosCollectViewCell.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/24.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_selectPhotosCollectViewCell.h"

@implementation MB_selectPhotosCollectViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    _coverView.hidden = !selected;
}

@end
