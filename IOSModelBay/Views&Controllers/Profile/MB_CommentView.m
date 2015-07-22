//
//  MB_CommentView.m
//  IOSModelBay
//
//  Created by lisongrc on 15/7/7.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_CommentView.h"

@implementation MB_CommentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = colorWithHexString(@"#747474");
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(frame) - 66, CGRectGetHeight(frame))];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:LocalizedString(@"Leave Message", nil)];
        [string addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"#ffffff") range:NSMakeRange(0, string.length)];
        _textField.attributedPlaceholder = string;
        _textField.textColor = colorWithHexString(@"#ffffff");
        _textField.font = [UIFont fontWithName:@"CenturyGothic" size:13];
        _textField.returnKeyType = UIReturnKeyDone;
        [self addSubview:_textField];
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(CGRectGetWidth(frame) - 66, 0, 66, CGRectGetHeight(frame));
        _sendButton.backgroundColor = colorWithHexString(@"#444444");
        _sendButton.titleLabel.font = [UIFont fontWithName:@"CenturyGothic" size:13];
        [_sendButton setTitle:LocalizedString(@"Send", nil) forState:UIControlStateNormal];
        [self addSubview:_sendButton];
    }
    return self;
}

@end
