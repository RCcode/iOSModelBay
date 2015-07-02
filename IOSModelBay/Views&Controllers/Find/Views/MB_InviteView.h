//
//  MB_InviteView.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/12.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InviteViewDelegate <NSObject>

@optional
- (void)textFieldReturnClick:(UITextField *)textField;
- (void)inviteRightViewOnClick:(UIButton *)button;

@end

@interface MB_InviteView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, weak) id<InviteViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<InviteViewDelegate>)delegate;

@end
