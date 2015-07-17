//
//  MB_EditAgeViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/7/14.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_EditWriteViewController.h"

@interface MB_EditWriteViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@end

@implementation MB_EditWriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = colorWithHexString(@"#eeeeee");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemOnClick:)];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(12, 100, kWindowWidth - 24, 200)];
    _textView.delegate = self;
    _textView.font = [UIFont fontWithName:@"FuturaStd-Book" size:14];
    _textView.textColor = colorWithHexString(@"#9a9a9a");
    _textView.text = self.text;
    [self.view addSubview:_textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"a"]) {
        textView.text = @"";
    }
    return YES;
}

#pragma mark - private methods
- (void)rightBarButtonItemOnClick:(UIBarButtonItem *)barButton {
    self.blcok(self.index, self.textView.text);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
