//
//  QMInterstitialDemoViewController.m
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import <QuMengAdSDK/QuMengAdSDK.h>
#import <Masonry/Masonry.h>

#import "QuMengSplashAdConf.h"
#import "QuMengSplashNativeView.h"
#import "ViewController.h"
#import "Tool.h"

#import "MBProgressHUD+QuMengAD.h"

@interface QuMengSplashAdConf ()<QuMengSplashAdDelegate>

@property (nonatomic, strong) QuMengSplashAd *splashAd;

@end

@implementation QuMengSplashAdConf

- (void)qumeng_loadAd:(NSDictionary *)item {
    NSString *slotID = item[@"slot"];
    _splashAd = [[QuMengSplashAd alloc] initWithSlot:slotID];
    _splashAd.adClickToCloseAutomatically = adClickToCloseAutomatically();
    _splashAd.delegate = self;
    [_splashAd loadAdData];
}

// MARK: - QuMengSplashAdDelegate
- (void)qumeng_splashAdLoadSuccess:(QuMengSplashAd *)splashAd {    
    QuMengLog(@"【媒体】开屏: 物料加载成功");
    
    // 检查广告有效性
    if (checkAdValid()) {
        [splashAd isValid];
    }
    
    NSDictionary *auctionInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"setAuctionInfo"];
    QuMengLog(@"【媒体】开屏: 竞价信息 %@", auctionInfo);
    
    NSString *channel = auctionInfo[@"channel"];
    NSString *price = auctionInfo[@"price"];
    if (splashAd.meta.getECPM >= price.integerValue) {
        QuMengLog(@"【媒体】开屏: 趣盟竞价成功，趣盟价格：%ld", (long)splashAd.meta.getECPM);
        [splashAd winNotice:price.integerValue];
    } else {
        QuMengLog(@"【媒体】开屏: 趣盟竞价失败，趣盟价格：%ld", (long)splashAd.meta.getECPM);
        [splashAd lossNotice:price.integerValue lossReason:QMLossReasonBaseFilter winBidder:channel];
        if (self.delegate && [self.delegate respondsToSelector:@selector(splashAdDidClose)]) {
            [self.delegate splashAdDidClose];
        }
        return;
    }
    
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (customBottomViewIsOpen()) {
        CGFloat width = [[UIScreen mainScreen] bounds].size.width;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 100)];
        view.backgroundColor = UIColor.whiteColor;
        UIImageView *imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"qumeng_logo"]];
        imageView.frame = CGRectMake(100, 35, 30, 30);
        [view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(160, 35, 200, 30)];
        label.text = @"欢迎接入趣盟";
        [view addSubview:label];
        
        if (adSplashWindow()) {
            // window 层级弹窗
            [splashAd showSplashWindow:keyWindow withBottomView:view];
        } else {
            //    当前页面如果是present vc 使用keyWindow.rootViewController会失效
            //   [splashAd showSplashViewController:keyWindow.rootViewController withBottomView:view];
            [splashAd showSplashViewController:Tool.topViewController withBottomView:view];
        }
        
    } else {
        if (adSplashWindow()) {
            [splashAd showSplashWindow:keyWindow];
        } else {
            //    当前页面如果是present vc 使用keyWindow.rootViewController会失效
            // [splashAd showSplashViewController: keyWindow.rootViewController];
            [splashAd showSplashViewController: Tool.topViewController];
        }
    }
}

- (void)qumeng_splashAdLoadFail:(QuMengSplashAd *)splashAd error:(NSError *)error {
    QuMengLog(@"【媒体】开屏: 物料加载失败");
    [MBProgressHUD showMessage:@"媒体开屏: 物料加载失败"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(splashAdDidClose)]) {
        [self.delegate splashAdDidClose];
    }
}

- (void)qumeng_splashAdRenderSuccess:(QuMengSplashAd *)splashAd {
    QuMengLog(@"【媒体】开屏: 物料渲染成功");
}

- (void)qumeng_splashAdRenderFail:(QuMengSplashAd *)splashAd error:(NSError *)error {
    QuMengLog(@"【媒体】开屏: 物料渲染失败 Error: %@", error);
}

- (void)qumeng_splashAdDidShow:(QuMengSplashAd *)splashAd {
    QuMengLog(@"【媒体】开屏: 曝光");
    [MBProgressHUD showMessage:@"媒体开屏: 曝光"];
}

- (void)qumeng_splashAdDidClick:(QuMengSplashAd *)splashAd {
    QuMengLog(@"【媒体】开屏: 点击");
    [MBProgressHUD showMessage:@"媒体开屏: 点击"];
}

- (void)qumeng_splashAdDidClose:(QuMengSplashAd *)splashAd closeType:(QuMengSplashAdCloseType)type {
    QuMengLog(@"【媒体】开屏: 关闭");
    self.splashAd = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(splashAdDidClose)]) {
        [self.delegate splashAdDidClose];
    }
}

- (void)qumeng_splashAdShowFail:(QuMengSplashAd *)splashAd error:(NSError *)error {
    self.splashAd = nil;
    QuMengLog(@"【媒体】开屏: show失败 error：%@", error);
    if (self.delegate && [self.delegate respondsToSelector:@selector(splashAdDidClose)]) {
        [self.delegate splashAdDidClose];
    }
}

@end


/// -----------------------------------------------开屏自渲染 -----------------------------------------------
//@interface QMSplashCustomAdConf: NSObject<QMSplashNativeAdDelegate, QuMengBaseConf>
//@property (nonatomic, assign) NSInteger countdownInterval;
//@property (nonatomic, strong) dispatch_source_t timer;
//@property (nonatomic, strong) QMSplashNativeAd *splashAd;
//@property (nonatomic, strong) QuMengSplashNativeView *adView;
//@end
//
//@implementation QMSplashCustomAdConf
//
//- (void)qumeng_loadAd:(NSDictionary *)item {
//    NSString *slotID = item[@"slot"];
//    self.splashAd = [[QMSplashNativeAd alloc] initWithSlot:slotID];
//    self.splashAd.delegate = self;
//    [self.splashAd loadAdData];
//}
//
//- (void) handleSkipBtnAction {
//    [self.adView removeFromSuperview];
//    [[UIApplication sharedApplication] keyWindow].rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
//}
//
//// MARK: - QMSplashNativeAdDelegate
///// 开屏广告加载成功
//- (void)qumeng_splashAdLoadSuccess:(QMSplashNativeAd * _Nonnull)splashAd {
//    QuMengLog(@"【媒体】开屏: 物料加载\n");    
//    UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
//    QuMengSplashNativeView *view = [[QuMengSplashNativeView alloc] initWithSplashNativeAd:splashAd];
//    view.frame = rootView.bounds;
//    view.backgroundColor = UIColor.whiteColor;
//    [view.skipBtn addTarget:self action:@selector(handleSkipBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [rootView addSubview:view];
//    self.adView = view;
//    [splashAd registerContainer:view withClickableViews:@[view.actionBtn]];
//    
//    dispatch_queue_t queue = dispatch_get_main_queue();
//    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    // 设置定时器的启动时间
//    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 0);
//    // 设置定时器的间隔时间和重复次数
//    dispatch_source_set_timer(self.timer, start, 1 * NSEC_PER_SEC, 0);
//    __block NSInteger remainingTime = 5;
//    
//    __weak typeof(self) weakSelf = self;
//    dispatch_source_set_event_handler(weakSelf.timer, ^{
//        if (remainingTime > 0) {
//            [view.skipBtn setTitle:[NSString stringWithFormat:@"跳过%ld",(long)remainingTime] forState:UIControlStateNormal];
//            QuMengLog(@"倒计时: %ld 秒", (long)remainingTime);
//            remainingTime -= 1;
//        } else {
//            QuMengLog(@"倒计时结束！");
//            dispatch_source_cancel(weakSelf.timer);
//            [weakSelf handleSkipBtnAction];
//        }
//    });
//    
//    dispatch_resume(self.timer);
//}
//
//- (void)dealloc
//{
//    if (self.timer) {
//        dispatch_source_cancel(self.timer);  // 确保在析构时取消计时器
//        self.timer = nil;
//    }
//}
//
///// 开屏广告加载失败
//- (void)qumeng_splashAdLoadFail:(QMSplashNativeAd * _Nonnull)splashAd error:(NSError * _Nullable)error {
//    QuMengLog(@"【媒体】开屏: 物料加载失败");
//    [MBProgressHUD showMessage:@"媒体开屏: 物料加载失败"];
//    [[UIApplication sharedApplication] keyWindow].rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
//}
//
///// 开屏广告曝光
//- (void)qumeng_splashAdDidShow:(QMSplashNativeAd * _Nonnull)splashAd {
//    QuMengLog(@"【媒体】开屏: 曝光");
//    [MBProgressHUD showMessage:@"媒体开屏: 曝光"];
//}
//
///// 开屏广告点击
//- (void)qumeng_splashAdDidClick:(QMSplashNativeAd * _Nonnull)splashAd {
//    QuMengLog(@"【媒体】开屏: 点击");
//    [MBProgressHUD showMessage:@"媒体开屏: 点击"];
//}
//
///// 开屏广告关闭
//- (void)qumeng_splashAdDidClose:(QMSplashNativeAd * _Nonnull)splashAd closeType:(enum QuMengSplashAdCloseType)type {
//    QuMengLog(@"【媒体】开屏: 关闭");
//    [MBProgressHUD showMessage:@"开屏: 关闭"];
//    [[UIApplication sharedApplication] keyWindow].rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
//}
//
//@end
