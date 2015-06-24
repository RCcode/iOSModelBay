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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNotice:(MB_Notice *)notice {
    _notice = notice;
    
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:notice.fpic] placeholderImage:nil];
    _usernameLabel.text = notice.fname;
    _messageLabel.text = notice.comment;
    _timeLabel.text = [NSString stringWithFormat:@"%f",notice.create_time];
    
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
