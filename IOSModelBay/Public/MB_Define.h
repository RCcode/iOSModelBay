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

#define kMoreAppID 24001
//#define kAdmobID   @"ca-app-pub-3747943735238482/3196343450"

#define kAppID               @"1007018487"
#define kAppStoreScoreURLPre @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id="
#define kAppStoreScoreURL [NSString stringWithFormat:@"%@%@", kAppStoreScoreURLPre, kAppID]

#define kFeedbackEmail           @"rcplatform.help@gmail.com"
#define kFollwUsInstagramAccount @"modelbayapp"
#define kFollwUsInstagramURL     @"http://www.instagram.com/modelbayapp"
#define kFollowUsFacebookUrl     @"https://www.facebook.com/pages/ModelBay/832690196767719"

//Instragram平台用户信息
#define kUid         @"uid"
#define kUsername    @"username"
#define kFullname    @"fullname"
#define kAccessToken @"accessToken"
#define kBio         @"bio"
#define kWebsite     @"website"

//模特平台用户信息
#define kIsLogin @"isLogin"
#define kID      @"id"
#define kName    @"name"
#define kCareer  @"career"
#define kGender  @"gender"
#define kUtype   @"utype"
#define kPic     @"pic"
#define kBackPic @"backPic"
#define kToken   @"token"

#define kDeleteAblum @"deletedAblum"

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
#define kLoginInNotification  @"loginInNotification"
//退出登录通知
#define kLoginOutNotification @"loginOutNotification"
//刷新影集列表通知
#define kRefreshAblumNotification @"refreshAblumNotification"

//收藏次数
#define kCollectCount @"collectCount"
//评分提示弹出次数
#define kRateAlertShowCount  @"rateAlertShowCount"
//是否可以弹出评分提示
#define kCanshowRateAlert    @"canshowRateAlert"

#endif
