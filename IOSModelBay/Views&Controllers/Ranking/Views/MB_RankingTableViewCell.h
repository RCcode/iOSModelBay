//
//  MB_RankingTableViewCell.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/13.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MB_User.h"

@interface MB_RankingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView  *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView  *userImageView;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;

@property (weak, nonatomic) IBOutlet UILabel      *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel      *descLabel;
//@property (weak, nonatomic) IBOutlet UIButton     *collectButton;
@property (weak, nonatomic) IBOutlet UIScrollView *ablumScrollView;
@property (weak, nonatomic) IBOutlet UIImageView  *rankImageView;

@property (nonatomic, strong) MB_User *user;

@end
