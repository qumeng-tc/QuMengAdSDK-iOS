//
//  QMInterstitialDemoViewController.m
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import <QuMengAdSDK/QuMengAdSDK-Swift.h>
#import <Masonry.h>

#import "QuMengInterstitialConf.h"
#import "MBProgressHUD+QuMengAD.h"
#import "QuMengBaseConf.h"
#import "ViewController.h"

// 插屏
@interface QuMengInterstitialConf ()<QuMengInterstitialAdDelegate, QuMengBaseConf>
@property (nonatomic, strong) QuMengInterstitialAd *interstitialAd;

@end

@implementation QuMengInterstitialConf

- (void)qumeng_loadAd:(NSDictionary *)item {
    NSString *slotID = item[@"slot"];
    _interstitialAd = [[QuMengInterstitialAd alloc] initWithSlot:slotID];
    
    /// 广告点击自动关闭，不需要可以不传
    _interstitialAd.adClickToCloseAutomatically = adClickToCloseAutomatically();
    _interstitialAd.delegate = self;
    [_interstitialAd loadAdData];
}


// MARK: - QuMengInterstitialAdDelegate
- (void)qumeng_interstitialAdLoadSuccess:(QuMengInterstitialAd *)interstitialAd {
    NSLog(@"【媒体】插屏: 请求成功");
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [interstitialAd showInterstitialViewInRootViewController: keyWindow.rootViewController];
}

- (void)qumeng_interstitialAdLoadFail:(QuMengInterstitialAd *)interstitialAd error:(NSError *)error {
    NSLog(@"【媒体】插屏: 请求失败");
    [MBProgressHUD showMessage:@"媒体插屏: 请求失败"];
}

- (void)qumeng_interstitialAdDidShow:(QuMengInterstitialAd *)interstitialAd {
    NSLog(@"【媒体】插屏: 曝光");
}

- (void)qumeng_interstitialAdDidClick:(QuMengInterstitialAd *)interstitialAd {
    NSLog(@"【媒体】插屏: 点击");
    [MBProgressHUD showMessage:@"媒体插屏: 点击"];
}

- (void)qumeng_interstitialAdDidCloseOtherController:(QuMengInterstitialAd *)interstitialAd {
    NSLog(@"【媒体】插屏: 关闭落地页");
}

- (void)qumeng_interstitialAdDidClose:(QuMengInterstitialAd *)interstitialAd closeType:(QuMengInterstitialAdCloseType)type {
    NSLog(@"【媒体】插屏: 关闭广告");
}

/// 插屏广告视频播放开始
- (void)qumeng_interstitialAdDidStart:(QuMengInterstitialAd *)rewardedVideoAd {
    NSLog(@"【媒体】插屏: 视频播放开始");
}
/// 插屏广告视频播放暂停
- (void)qumeng_interstitialAdDidPause:(QuMengInterstitialAd *)rewardedVideoAd {
    NSLog(@"【媒体】插屏: 视频播放暂停");
}
/// 插屏广告视频播放继续
- (void)qumeng_interstitialAdDidResume:(QuMengInterstitialAd *)rewardedVideoAd {
    NSLog(@"【媒体】插屏: 视频播放继续");
}

- (void)qumeng_interstitialAdVideoDidPlayComplection:(QuMengInterstitialAd *)interstitialAd {
    NSLog(@"【媒体】插屏: 视频播放完成");
}

- (void)qumeng_interstitialAdVideoDidPlayFinished:(QuMengInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    NSLog(@"【媒体】插屏: 视频播放异常");
    [MBProgressHUD showMessage:@"媒体插屏: 视频播放异常"];
}
 

@end
