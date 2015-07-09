//
//  MB_MessageReplyTableViewCell.m
//  IOSModelBay
//
//  Created by lisong on 15/7/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_MessageReplyTableViewCell.h"

@implementation MB_MessageReplyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNotice:(MB_Notice *)notice {
    _notice = notice;
    
//    [_userImageView sd_setImageWithURL:[NSURL URLWithString:notice.fpic] placeholderImage:nil];
//    _usernameLabel.text = notice.fname;
//    _messageLabel.text = notice.comment;
//    _timeLabel.text = [NSString stringWithFormat:@"%f",notice.createTime];
    
    switch (notice.mtype) {
        case NoticeTypeCollect: {
            
            break;
        }
        case NoticeTypeMention: {
            
            break;
        }
        case NoticeTypeLike: {
            
            break;
        }
        case NoticeTypeComment: {
            
            break;
        }
        case NoticeTypeMessage: {
            
            break;
        }
        case NoticeTypeReplay: {
            
            break;
        }
        default: {
            break;
        }
    }
}

@end
