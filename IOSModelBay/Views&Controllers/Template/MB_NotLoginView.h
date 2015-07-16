//
//  MB_NotLoginView.h
//  IOSModelBay
//
//  Created by lisongrc on 15/7/16.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NotLoginViewDelegate <NSObject>

- (void)notLoginViewOnClick:(UITapGestureRecognizer *)tap;

@end

@interface MB_NotLoginView : UIView

@property (nonatomic, strong) UIView *contanerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, weak) id<NotLoginViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text delegate:(id<NotLoginViewDelegate>)delegate;

@end
