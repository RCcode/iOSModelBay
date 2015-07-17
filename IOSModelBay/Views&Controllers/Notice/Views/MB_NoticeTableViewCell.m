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
    _timeLabel.text = [MB_Utils dateWithTimeInterval:notice.createTime * 1000 fromTimeZone:@"+08"];
    
    switch (notice.mtype) {
        case NoticeTypeCollect:
        {
            _contentLabel.text = [LocalizedString(@"Favored_you", nil) stringByReplacingOccurrencesOfString:@"xxxx" withString:notice.fname];
            _relateImageView.hidden = YES;
            break;
        }
        case NoticeTypeMention:
        {
            _contentLabel.text = [LocalizedString(@"mentioned_you", nil) stringByReplacingOccurrencesOfString:@"xxxx" withString:notice.fname];
            _relateImageView.hidden = NO;
            [_relateImageView sd_setImageWithURL:[NSURL URLWithString:notice.mpic] placeholderImage:nil];
            break;
        }
        case NoticeTypeComment:
        {
            _contentLabel.text = [LocalizedString(@"comment_your_photo", nil) stringByReplacingOccurrencesOfString:@"xxxx" withString:notice.fname];
            _relateImageView.hidden = NO;
            [_relateImageView sd_setImageWithURL:[NSURL URLWithString:notice.mpic] placeholderImage:nil];
            break;
        }
        case NoticeTypeLike:
        {
            _contentLabel.text = [LocalizedString(@"liked_your_photo", nil) stringByReplacingOccurrencesOfString:@"xxxx" withString:notice.fname];
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
