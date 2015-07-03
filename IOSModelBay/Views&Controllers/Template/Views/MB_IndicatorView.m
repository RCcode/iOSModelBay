//
//  MB_IndicatorView.m
//  IOSModelBay
//
//  Created by lisongrc on 15/7/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_IndicatorView.h"

@implementation MB_IndicatorView

- (instancetype)initWithFrame:(CGRect)frame pageCount:(NSInteger)page
{
    self = [super initWithFrame:frame];
    if (self) {
        _pageCount = page;
        _indicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame) / page, CGRectGetHeight(frame))];
        _indicator.backgroundColor = colorWithHexString(@"#ff4f42");
        [self addSubview:_indicator];
    }
    return self;
}

-(void)setCurrentPage:(NSInteger)currentPage {
    [UIView animateWithDuration:0.1 animations:^{
        CGRect rect =  _indicator.frame;
        rect.origin.x = self.frame.size.width * currentPage / _pageCount;
        _indicator.frame = rect;
        
    }];
}


@end
