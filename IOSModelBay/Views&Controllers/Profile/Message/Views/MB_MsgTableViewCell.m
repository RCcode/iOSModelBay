//
//  MB_MsgTableViewCell.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/13.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_MsgTableViewCell.h"

@implementation MB_MsgTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setMessage:(MB_Message *)message {
    _message = message;
    _userButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_userButton sd_setBackgroundImageWithURL:[NSURL URLWithString:message.fpic] forState:UIControlStateNormal];
    _nameLabel.text = message.fname.uppercaseString;
    _timeLabel.text = [MB_Utils dateWithTimeInterval:message.createTime * 1000 fromTimeZone:@"+08"];
    _commentLabel.text = message.comment;
}

@end
