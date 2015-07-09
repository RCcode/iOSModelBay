//
//  MB_MessageTableViewCell.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/24.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_MessageTableViewCell.h"

@implementation MB_MessageTableViewCell

- (void)awakeFromNib {
    self.layoutMargins = UIEdgeInsetsZero;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setNotice:(MB_Notice *)notice {
    _notice = notice;
    
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:notice.fpic] placeholderImage:nil];
    _usernameLabel.text = notice.fname.uppercaseString;
    _messageLabel.text = notice.comment;
    _timeLabel.text = [MB_Utils dateWithTimeInterval:notice.createTime * 1000 fromTimeZone:@"+08"];
    
    switch (notice.mtype) {
        case NoticeTypeMessage: {
            _typeLabel.text = @"aaaa".uppercaseString;
            break;
        }
            
        case NoticeTypeReplay: {
            _typeLabel.text = @"bbb".uppercaseString;
            break;
        }
            
        default: {
            break;
        }
    }
}

@end
