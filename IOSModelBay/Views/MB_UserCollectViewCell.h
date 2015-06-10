//
//  MB_UserCollectViewCell.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MB_UserCollectViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *IconImageView;//头像
@property (weak, nonatomic) IBOutlet UILabel     *usernameLabel;//名字
@property (weak, nonatomic) IBOutlet UIView      *careerView;   //职业 个数最少1个最多3个

@end
