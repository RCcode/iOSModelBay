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
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        textField.placeholder = @"ADD A COMMENT";
//        textField.textColor = 
    }
    return self;
}

@end
