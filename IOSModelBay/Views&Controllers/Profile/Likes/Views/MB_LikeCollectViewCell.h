//
//  MB_LikeCollectViewCell.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/15.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MB_Collect.h"

@interface MB_LikeCollectViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) MB_Collect *collect;

@end
