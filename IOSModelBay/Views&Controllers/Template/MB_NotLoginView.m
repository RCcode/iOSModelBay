//
//  MB_NotLoginView.m
//  IOSModelBay
//
//  Created by lisongrc on 15/7/16.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_NotLoginView.h"

@implementation MB_NotLoginView

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text delegate:(id<NotLoginViewDelegate>)delegate{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
        _delegate = delegate;
        _text     = text;
        
        _contanerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame) - 30, 0)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notLoginViewTaped:)];
        [_contanerView addGestureRecognizer:tap];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 31, 31)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image       = [UIImage imageNamed:@"ic_nologin"];
        [_contanerView addSubview:_imageView];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame) + 14, CGRectGetWidth(_contanerView.frame), 0)];
        _label.numberOfLines = 0;
        _label.font          = [UIFont fontWithName:@"FuturaStd-Book" size:12];
        _label.textColor     = colorWithHexString(@"#595959");
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text          = self.text;
        [_label sizeToFit];
        CGRect rect      = _label.frame;
        rect.size.height += 4;
        _label.frame     = rect;
        [_contanerView addSubview:_label];
        
        //调整整体的布局
        _contanerView.frame  = CGRectMake(0, 0, fmax(CGRectGetWidth(_label.frame), 31), CGRectGetMaxY(_label.frame));
        _contanerView.center = self.center;
        _imageView.center    = CGPointMake(CGRectGetWidth(_contanerView.frame) / 2, 31.0 / 2);
        _label.center        = CGPointMake(CGRectGetWidth(_contanerView.frame) / 2, _label.center.y);
        
        [self addSubview:_contanerView];
    }
    return self;
}

//点击方法
- (void)notLoginViewTaped:(UITapGestureRecognizer *)tap {
    if ([_delegate respondsToSelector:@selector(notLoginViewOnClick:)]) {
        [_delegate notLoginViewOnClick:tap];
    }
}

@end
