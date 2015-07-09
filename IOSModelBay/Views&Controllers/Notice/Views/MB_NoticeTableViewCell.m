//
//  MB_NoticeTableViewCell.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/24.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_NoticeTableViewCell.h"

@implementation MB_NoticeTableViewCell

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
    _contentLabel.text = notice.comment;
    _timeLabel.text = [MB_Utils dateWithTimeInterval:notice.createTime * 1000 fromTimeZone:@"+08"];

    switch (notice.mtype) {
        case NoticeTypeCollect:
        case NoticeTypeMessage:
        case NoticeTypeReplay:
        {
            _relateImageView.hidden = YES;
            break;
        }
            
        case NoticeTypeMention:
        case NoticeTypeComment:
        case NoticeTypeLike:
        {
            _relateImageView.hidden = NO;
            [_relateImageView sd_setImageWithURL:[NSURL URLWithString:notice.mpic] placeholderImage:nil];
            break;
        }
            
        default: {
            break;
        }
    }
}

@end
