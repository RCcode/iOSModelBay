//
//  MB_ReplyTableViewCell.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/15.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_ReplyTableViewCell.h"

@implementation MB_ReplyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessage:(MB_Message *)message {
    _message = message;
    _userButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_userButton sd_setBackgroundImageWithURL:[NSURL URLWithString:message.fpic] forState:UIControlStateNormal];
    _nameLabel.text = message.fname;
    _timeLabel.text = [MB_Utils dateWithTimeInterval:message.createTime * 1000 fromTimeZone:@"+08"];
    _commentLabel.text = message.comment;
    
    _replyNameLabel.text = message.replyName;
    _replyTimeLabel.text = [MB_Utils dateWithTimeInterval:message.replyTime * 1000 fromTimeZone:@"+08"];
    _replyLabel.text = message.reply;
}
@end
