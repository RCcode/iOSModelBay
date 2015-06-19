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
        _backView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.5];
        [self addSubview:_backView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_backView addGestureRecognizer:tap];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, kWindowWidth, 100)];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.rightViewMode = UITextFieldViewModeAlways;
        [self addSubview:_textField];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setFrame:CGRectMake(0, 0, 30, 30)];
        [_rightButton setImage:[UIImage imageNamed:@"b"] forState:UIControlStateNormal];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
