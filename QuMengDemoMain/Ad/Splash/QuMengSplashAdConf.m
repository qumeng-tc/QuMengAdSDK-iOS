//
//  QMInterstitialDemoViewController.m
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import <QuMengAdSDK/QuMengAdSDK-Swift.h>
#import <Masonry.h>

#import "QuMengSplashAdConf.h"
#import "MBProgressHUD+QuMengAD.h"
#import "QuMengBaseConf.h"
#import "QuMengSplashNativeView.h"
#import "ViewController.h"
@interface QuMengSplashAdConf ()<QuMengSplashAdDelegate, QuMengBaseConf>
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
    NSLog(@"【媒体】开屏: 物料加载成功\n");
    [MBProgressHUD showMessage:@"媒体开屏: 物料加载成功"];
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
        [splashAd showSplashViewController:keyWindow.rootViewController winthBottomView:view];
    } else {
        [splashAd showSplashViewController: keyWindow.rootViewController];
    }
}

- (void)qumeng_splashAdLoadFail:(QuMengSplashAd *)splashAd error:(NSError *)error {
    NSLog(@"【媒体】开屏: 物料加载失败");
    [MBProgressHUD showMessage:@"媒体开屏: 物料加载失败"];
    UIViewController *vc = [[[UIApplication sharedApplication] keyWindow].rootViewController childViewControllers].firstObject;
    if (![vc isKindOfClass:ViewController.self]) {
        [[UIApplication sharedApplication] keyWindow].rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    }
}

- (void)qumeng_splashAdDidShow:(QuMengSplashAd *)splashAd {
    NSLog(@"【媒体】开屏: 曝光");
    [MBProgressHUD showMessage:@"媒体开屏: 曝光"];
}

- (void)qumeng_splashAdDidClick:(QuMengSplashAd *)splashAd {
    NSLog(@"【媒体】开屏: 点击");
    [MBProgressHUD showMessage:@"媒体开屏: 点击"];
}

- (void)qumeng_splashAdDidClose:(QuMengSplashAd *)splashAd closeType:(QuMengSplashAdCloseType)type {
    NSLog(@"【媒体】开屏: 关闭");
    [MBProgressHUD showMessage:@"开屏: 关闭"];
    [[UIApplication sharedApplication] keyWindow].rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
}

- (void)qumeng_splashAdVideoDidPlayFinished:(QuMengSplashAd *)splashAd didFailWithError:(NSError *)error {
    NSLog(@"【媒体】开屏: 视频播放异常");
}

@end


/// -----------------------------------------------开屏自渲染 -----------------------------------------------
@interface QMSplashCustomAdConf: NSObject<QuMengSplashNativeAdDelegate, QuMengBaseConf>
@property (nonatomic, assign) NSInteger countdownInterval;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) QuMengSplashNativeAd *splashAd;
@property (nonatomic, strong) QuMengSplashNativeView *adView;
@end

@implementation QMSplashCustomAdConf

- (void)qumeng_loadAd:(NSDictionary *)item {
    NSString *slotID = item[@"slot"];
    self.splashAd = [[QuMengSplashNativeAd alloc] initWithSlot:slotID];
    self.splashAd.delegate = self;
    [self.splashAd loadAdData];
}

- (void) handleSkipBtnAction {
    [self.adView removeFromSuperview];
    [[UIApplication sharedApplication] keyWindow].rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
}

// MARK: - QuMengSplashNativeAdDelegate
/// 开屏广告加载成功
- (void)qumeng_splashAdLoadSuccess:(QuMengSplashNativeAd * _Nonnull)splashAd {
    NSLog(@"【媒体】开屏: 物料加载\n");    
    UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    QuMengSplashNativeView *view = [[QuMengSplashNativeView alloc] initWithSplashNativeAd:splashAd];
    view.frame = rootView.bounds;
    view.backgroundColor = UIColor.whiteColor;
    [view.skipBtn addTarget:self action:@selector(handleSkipBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:view];
    self.adView = view;
    [splashAd registerContainer:view withClickableViews:@[view.actionBtn]];
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 设置定时器的启动时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 0);
    // 设置定时器的间隔时间和重复次数
    dispatch_source_set_timer(self.timer, start, 1 * NSEC_PER_SEC, 0);
    __block NSInteger remainingTime = 5;
    
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(weakSelf.timer, ^{
        if (remainingTime > 0) {
            [view.skipBtn setTitle:[NSString stringWithFormat:@"跳过%ld",(long)remainingTime] forState:UIControlStateNormal];
            NSLog(@"倒计时: %ld 秒", (long)remainingTime);
            remainingTime -= 1;
        } else {
            NSLog(@"倒计时结束！");
            dispatch_source_cancel(weakSelf.timer);
            [weakSelf handleSkipBtnAction];
        }
    });
    
    dispatch_resume(self.timer);
}

- (void)dealloc
{
    if (self.timer) {
        dispatch_source_cancel(self.timer);  // 确保在析构时取消计时器
        self.timer = nil;
    }
}

/// 开屏广告加载失败
- (void)qumeng_splashAdLoadFail:(QuMengSplashNativeAd * _Nonnull)splashAd error:(NSError * _Nullable)error {
    NSLog(@"【媒体】开屏: 物料加载失败");
    [MBProgressHUD showMessage:@"媒体开屏: 物料加载失败"];
    [[UIApplication sharedApplication] keyWindow].rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
}

/// 开屏广告曝光
- (void)qumeng_splashAdDidShow:(QuMengSplashNativeAd * _Nonnull)splashAd {
    NSLog(@"【媒体】开屏: 曝光");
    [MBProgressHUD showMessage:@"媒体开屏: 曝光"];
}

/// 开屏广告点击
- (void)qumeng_splashAdDidClick:(QuMengSplashNativeAd * _Nonnull)splashAd {
    NSLog(@"【媒体】开屏: 点击");
    [MBProgressHUD showMessage:@"媒体开屏: 点击"];
}

/// 开屏广告关闭
- (void)qumeng_splashAdDidClose:(QuMengSplashNativeAd * _Nonnull)splashAd closeType:(enum QuMengSplashAdCloseType)type {
    NSLog(@"【媒体】开屏: 关闭");
    [MBProgressHUD showMessage:@"开屏: 关闭"];
    [[UIApplication sharedApplication] keyWindow].rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
}

@end
