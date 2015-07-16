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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemOnClick:)];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, kWindowWidth - 20, 200)];
    _textView.delegate = self;
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
