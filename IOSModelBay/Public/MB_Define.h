//
//  MB_Define.h
//  IOSModelBay
//
//  Created by lisongrc on 15/6/2.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#ifndef IOSModelBay_MB_Define_h
#define IOSModelBay_MB_Define_h

#define kWindowWidth  [UIScreen mainScreen].bounds.size.width
#define kWindowHeight [UIScreen mainScreen].bounds.size.height

//Instragram
#define kClientID     @"50fe4270c00d4a3ab743c7aa0926aa70"
#define kClientSecret @"6bce4c423a0349f1819c3ecfcb873a9b"
#define kRedirectUri  @"https://www.facebook.com/pages/ModelBay/832690196767719"
#define kWebsiteUrl   @"https://www.facebook.com/pages/ModelBay/832690196767719"

//友盟与Flurry
#define kUmengAppKey  @"556e66fd67e58ee877006d64"
#define kFlurryAppKey @"JVB6C3SPS7K7NPNN86ZH"

//#define kAppID     @"878086629"
//#define kMoreAppID 20051
//#define kAdmobID   @"ca-app-pub-3747943735238482/3196343450"

//Instragram平台用户信息
#define kUid @"uid"
#define kUsername @"username"
#define kFullname @"fullname"
#define kAccessToken @"accessToken"
#define kBio @"bio"
#define kWebsite @"website"

//模特平台用户信息
#define kIsLogin @"isLogin"
#define kID   @"id"
#define kName @"name"
#define kCareer @"career"
#define kGender @"gender"
#define kUtype @"utype"
#define kPic @"pic"
#define kBackPic @"backPic"
#define kToken @"token"


#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif

//userDefaults
#define userDefaults [NSUserDefaults standardUserDefaults]

//imageView加载出图片之前的默认背景色
#define placeholderColor colorWithHexString(@"#e3e3e3")

//登录通知
#define kLoginInNotification @"loginInNotification"
//退出登录通知
#define kLoginOutNotification @"loginOutNotification"





//AppStore
//#define kAppStoreUrlPre @"itms-apps://itunes.apple.com/app/id"
//#define kAppStoreUrl [NSString stringWithFormat:@"%@%@", kAppStoreUrlPre, kAppID]
//#define kAppStoreScoreUrlPre @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id="
//#define kAppStoreScoreUrl [NSString stringWithFormat:@"%@%@", kAppStoreScoreUrlPre, kAppID]

//#define FEEDBACK_EMAIL @"rcplatform.help@gmail.com"
//#define FOLLOW_US_URL  @"http://www.instagram.com/nocrop_rc"

#endif
