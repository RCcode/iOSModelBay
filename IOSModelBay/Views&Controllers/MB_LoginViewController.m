//
//  MB_LoginViewController.m
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "MB_LoginViewController.h"

@interface MB_LoginViewController ()<UIWebViewDelegate>

@end

@implementation MB_LoginViewController

- (instancetype)initWithSuccessBlock:(LoginSuccessBlock)success {
    self = [super init];
    if (self) {
        _loginSuccessBlock = success;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = colorWithHexString(@"#eeeeee");
    self.title = LocalizedString(@"Login", nil);
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButonOnClick:)];
    self.navigationItem.leftBarButtonItem = barButton;
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    web.delegate = self;
    [self.view addSubview:web];
    
    NSString *loginUrl = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code&scope=relationships",kClientID,kRedirectUri];
    NSURL *url = [NSURL URLWithString:loginUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
}

- (void)cancelButonOnClick:(UIBarButtonItem *)barButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString rangeOfString:@"code="].length > 0) {
        NSString *codeStr = [[request.URL.absoluteString componentsSeparatedByString:@"code="] lastObject];
        NSLog(@"absoluteString == %@",request.URL.absoluteString);
        NSLog(@"code = %@",codeStr);
        [self dismissViewControllerAnimated:YES completion:^{
            _loginSuccessBlock(codeStr);
        }];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        [MB_Utils showPromptWithText:LocalizedString(@"login_failed", nil)];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
