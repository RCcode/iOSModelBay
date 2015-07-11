//
//  MB_CommentTableViewCell.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/19.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_CommentTableViewCell.h"

@implementation MB_CommentTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setComment:(MB_Comment *)comment {
    _comment = comment;
    
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:comment.fpic]];
    _usernameLabel.text = comment.fname.uppercaseString;
    _commentLabel.text = comment.comment;
    _timeLabel.text = [MB_Utils dateWithTimeInterval:comment.create_time * 1000 fromTimeZone:@"+08"];
}

@end
