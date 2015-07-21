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
@property (nonatomic, strong) UIDatePicker *picker;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIButton *hideButton;
@property (nonatomic, strong) UIButton *noHideButton;

@end

@implementation MB_EditWriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = colorWithHexString(@"#eeeeee");
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemOnClick:)];
    
    
    if (self.index != 18 && self.index != 0) {
        _hideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _hideButton.frame = CGRectMake(0, 250, 100, 100);
        [_hideButton setImage:[UIImage imageNamed:@"ic_wz"] forState:UIControlStateNormal];
        [_hideButton setImage:[UIImage imageNamed:@"ic_cz"] forState:UIControlStateSelected];
        [_hideButton setTitleColor:colorWithHexString(@"#8f8f8f") forState:UIControlStateNormal];
        [_hideButton setTitleColor:colorWithHexString(@"#ff4f42") forState:UIControlStateSelected];
        [_hideButton setTitle:@"aaa" forState:UIControlStateNormal];
        [_hideButton addTarget:self action:@selector(hideOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_hideButton];
        
        _noHideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _noHideButton.frame = CGRectMake(200, 250, 100, 100);
        [_noHideButton setImage:[UIImage imageNamed:@"ic_wz"] forState:UIControlStateNormal];
        [_noHideButton setImage:[UIImage imageNamed:@"ic_cz"] forState:UIControlStateSelected];
        [_noHideButton setTitleColor:colorWithHexString(@"#8f8f8f") forState:UIControlStateNormal];
        [_noHideButton setTitleColor:colorWithHexString(@"#ff4f42") forState:UIControlStateSelected];
        [_noHideButton setTitle:@"bbb" forState:UIControlStateNormal];
        [_noHideButton addTarget:self action:@selector(notHideOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_noHideButton];
    }
    
    switch (self.index) {
        case 15://age
        {
            _picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth, 0)];
            _picker.datePickerMode = UIDatePickerModeDate;
            _picker.date = [NSDate dateWithTimeIntervalSince1970:[self.text integerValue]];
            _picker.maximumDate = [NSDate date];
            [self.view addSubview:_picker];
            break;
        }
        case 0://bio
        {
            _textView = [[UITextView alloc] initWithFrame:CGRectMake(12, 64, kWindowWidth - 24, 216)];
            _textView.delegate = self;
            _textView.font = [UIFont fontWithName:@"FuturaStd-Book" size:14];
            _textView.textColor = colorWithHexString(@"#9a9a9a");
            _textView.text = self.text;
            _textView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_textView];
            break;
        }
            
        case 16://Contracts
        case 17://Email
        case 18://Website
        {
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(12, 100, kWindowWidth - 24, 50)];
            _textField.font = [UIFont fontWithName:@"FuturaStd-Book" size:14];
            _textField.textColor = colorWithHexString(@"#9a9a9a");
            _textField.text = self.text;
            _textField.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_textField];
            break;
        }
            
        default:
            break;
    }
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
    [self.textView resignFirstResponder];
    
    switch (self.index) {
        case 15://age
        {
            NSString *age = [NSString stringWithFormat:@"%.0f",[self.picker.date timeIntervalSince1970]];
            self.blcok(self.index, age, _hideButton.selected);
            break;
        }
        case 0://bio
        {
            self.blcok(self.index, self.textView.text, _hideButton.selected);
            break;
        }
            
        case 16://Contracts
        case 17://Email
        case 18://Website
        {
            self.blcok(self.index, self.textField.text, _hideButton.selected);
            break;
        }
            
        default:
            break;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideOnClick:(UIButton *)butotn {
    _hideButton.selected = YES;
    _noHideButton.selected = NO;
}

- (void)notHideOnClick:(UIButton *)butotn {
    _hideButton.selected = NO;
    _noHideButton.selected = YES;
}

@end
