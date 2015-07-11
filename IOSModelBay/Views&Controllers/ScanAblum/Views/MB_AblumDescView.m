//
//  MB_AblumDescView.m
//  IOSModelBay
//
//  Created by lisongrc on 15/7/3.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_AblumDescView.h"

@implementation MB_AblumDescView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton.frame = CGRectMake(10, 23, 21, 21);
        [_likeButton setImage:[UIImage imageNamed:@"ic_likes"] forState:UIControlStateNormal];
        [_likeButton addTarget:self action:@selector(likesButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_likeButton];
        
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentButton.frame = CGRectMake(CGRectGetMaxX(_likeButton.frame) + 80, 23, 21, 21);
        [_commentButton setImage:[UIImage imageNamed:@"ic_comment"] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(commentsButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_commentButton];
        
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.frame = CGRectMake(kWindowWidth - 40, 23, 21, 21);
        [_shareButton setImage:[UIImage imageNamed:@"ic_share"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_shareButton];
        
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.frame = CGRectMake((kWindowWidth - 11) / 2, CGRectGetMaxY(_likeButton.frame) + 13, 20, 20);
        [_moreButton setImage:[UIImage imageNamed:@"ic_sanjiao"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreButton];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_moreButton.frame) + 23, kWindowWidth, 40)];
        descLabel.numberOfLines = 0;
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.text = @"djhjhjhjhjjxxxxcccccccccccccccccccc\ndsdslkdsdkxccxcx\ncxvcxvcxxv\nscsdjdkfsdsd";
        descLabel.font = [UIFont fontWithName:@"ACaslonPro-Regular" size:16];
        descLabel.textColor = colorWithHexString(@"#ffffff");
        [descLabel sizeToFit];
        descLabel.center = CGPointMake(kWindowWidth / 2, CGRectGetMidY(descLabel.frame));
        [self addSubview:descLabel];

        UILabel *descLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(descLabel.frame) + 23, kWindowWidth, 15)];
        descLabel1.textAlignment = NSTextAlignmentCenter;
        descLabel1.text = @"aaaa";
        descLabel1.font = [UIFont fontWithName:@"CenturyGothic-Italic" size:10];
        descLabel1.textColor = colorWithHexString(@"#ffffff");
        [descLabel1 sizeToFit];
        descLabel1.center = CGPointMake(kWindowWidth / 2, CGRectGetMidY(descLabel1.frame));
        [self addSubview:descLabel1];

        UILabel *descLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(descLabel1.frame) + 10, kWindowWidth, 0)];
        descLabel2.textAlignment = NSTextAlignmentCenter;
        descLabel2.textColor = colorWithHexString(@"#ffffff");
        descLabel2.font = [UIFont fontWithName:@"CenturyGothic-Italic" size:10];
        NSString *str1 = @"摄影师";
        NSString *str2 = @"lisong";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, str1.length)];
        descLabel2.attributedText = str;
        [descLabel2 sizeToFit];
        descLabel2.center = CGPointMake(kWindowWidth / 2, CGRectGetMidY(descLabel2.frame));
        [self addSubview:descLabel2];
        
        UILabel *descLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(descLabel2.frame) + 10, kWindowWidth, 0)];
        descLabel3.textAlignment = NSTextAlignmentCenter;
        descLabel3.textColor = colorWithHexString(@"#ffffff");
        descLabel3.font = [UIFont fontWithName:@"CenturyGothic-Italic" size:10];
        descLabel3.attributedText = str;
        [descLabel3 sizeToFit];
        descLabel3.center = CGPointMake(kWindowWidth / 2, CGRectGetMidY(descLabel3.frame));
        [self addSubview:descLabel3];
        
        UILabel *descLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(descLabel3.frame) + 10, kWindowWidth, 0)];
        descLabel4.textAlignment = NSTextAlignmentCenter;
        descLabel4.textColor = colorWithHexString(@"#ffffff");
        descLabel4.font = [UIFont fontWithName:@"CenturyGothic-Italic" size:10];
        descLabel4.attributedText = str;
        [descLabel4 sizeToFit];
        descLabel4.center = CGPointMake(kWindowWidth / 2, CGRectGetMidY(descLabel4.frame));
        [self addSubview:descLabel4];
        
        //调整总大小
        self.frame = CGRectMake(0, 0, kWindowWidth, CGRectGetMaxY(descLabel4.frame) + 24);
    }
    return self;
}

- (void)likesButtonOnClick:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(likeButtonOnClick:)]) {
        [_delegate likeButtonOnClick:button];
    }
}

- (void)commentsButtonOnClick:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(commentButtonOnClick:)]) {
        [_delegate commentButtonOnClick:button];
    }
}

- (void)shareButtonOnClick:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(shareButtonOnClick:)]) {
        [_delegate shareButtonOnClick:button];
    }
}

- (void)moreButtonOnClick:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(moreButtonOnClick:)]) {
        [_delegate moreButtonOnClick:button];
    }
}

@end
