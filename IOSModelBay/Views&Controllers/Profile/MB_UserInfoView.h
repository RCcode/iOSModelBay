//
//  MB_UserInfoView.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/9.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MB_UserInfoView : UIView

@property (weak, nonatomic) IBOutlet UIImageView        *backImageView;
@property (weak, nonatomic) IBOutlet UIView             *coverView;
@property (weak, nonatomic) IBOutlet UIImageView        *userImageView;
@property (weak, nonatomic) IBOutlet UILabel            *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel            *careerLabel;
@property (weak, nonatomic) IBOutlet UIButton           *likeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likeLeading;
@property (weak, nonatomic) IBOutlet UIButton           *inviteButton;

@end
