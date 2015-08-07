//
//  MB_UserTableViewCell.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_UserTableViewCell.h"

@implementation MB_UserTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
//    self.layoutMargins = UIEdgeInsetsZero;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(MB_User *)user {
    _user = user;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:user.fpic] placeholderImage:nil];
    _usernameLabel.text = user.fname.uppercaseString;
    _fullnameLabel.text = user.ffullName.uppercaseString;
}

@end
