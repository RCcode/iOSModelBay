//
//  MB_InviteView.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/12.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_InviteView.h"

@implementation MB_InviteView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate {
    
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        _backView = [[UIView alloc] initWithFrame:frame];
        _backView.backgroundColor = [colorWithHexString(@"#222222") colorWithAlphaComponent:0.6];
        [self addSubview:_backView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_backView addGestureRecognizer:tap];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 69, kWindowWidth, 64)];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.rightViewMode = UITextFieldViewModeAlways;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        _textField.font = [UIFont fontWithName:@"CenturyGothic" size:15];
        [self addSubview:_textField];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 13);
        [_rightButton setFrame:CGRectMake(0, 0, 37, 40)];
        [_rightButton setImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _textField.rightView =  _rightButton;
    }
    return self;
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    [self removeFromSuperview];
}

- (void)rightButtonOnClick:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(inviteRightViewOnClick:)]) {
        [_delegate inviteRightViewOnClick:button];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(textFieldReturnClick:)]) {
        [_delegate textFieldReturnClick:textField];
    }
    return YES;
}

@end
