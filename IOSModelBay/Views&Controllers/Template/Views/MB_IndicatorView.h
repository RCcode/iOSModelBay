//
//  MB_IndicatorView.h
//  IOSModelBay
//
//  Created by lisongrc on 15/7/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MB_IndicatorView : UIView

@property (nonatomic, strong) UIView *indicator;

@property (nonatomic, assign) NSInteger pageCount;//总页数

@property (nonatomic, assign) NSInteger currentPage;//当前页数

- (instancetype)initWithFrame:(CGRect)frame pageCount:(NSInteger)page;

@end
