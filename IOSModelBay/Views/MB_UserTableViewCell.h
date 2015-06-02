//
//  MB_UserTableViewCell.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MB_UserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullnameLabel;

@end
