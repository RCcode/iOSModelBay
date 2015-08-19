//
//  MB_AblumDescView.h
//  IOSModelBay
//
//  Created by lisongrc on 15/7/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MB_Ablum.h"

@protocol AblumDescViewDelegate <NSObject>

@optional

- (void)likeButtonOnClick:(UIButton *)button;
- (void)likeCountLabelClick:(UITapGestureRecognizer *)tap;
- (void)commentButtonOnClick:(UIButton *)button;
- (void)shareButtonOnClick:(UIButton *)button;
- (void)moreButtonOnClick:(UIButton *)button;

@end

@interface MB_AblumDescView : UIView

@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UILabel *likeCountLabel;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, strong) MB_Ablum *ablum;

@property (nonatomic, weak) id<AblumDescViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame ablum:(MB_Ablum *)ablum;

@end
