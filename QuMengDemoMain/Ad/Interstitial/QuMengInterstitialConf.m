//
//  QMInterstitialDemoViewController.m
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import <QuMengAdSDK/QuMengAdSDK.h>
#import <Masonry/Masonry.h>

#import "QuMengInterstitialConf.h"
#import "QuMengBaseConf.h"
#import "ViewController.h"
#import "Tool.h"

#import "MBProgressHUD+QuMengAD.h"

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
    QuMengLog(@"【媒体】插屏: 请求成功");
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    //    当前页面如果是present vc 使用keyWindow.rootViewController会失效
    //    [interstitialAd showInterstitialViewInRootViewController: keyWindow.rootViewController];
    
    // 检查广告有效性
    if (checkAdValid()) {
        [interstitialAd isValid];
    }
    
    NSDictionary *auctionInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"setAuctionInfo"];
    QuMengLog(@"【媒体】插屏: 竞价信息 %@", auctionInfo);
    
    NSString *channel = auctionInfo[@"channel"];
    NSString *price = auctionInfo[@"price"];
    if (interstitialAd.meta.getECPM >= price.integerValue) {
        QuMengLog(@"【媒体】插屏: 趣盟竞价成功，趣盟价格：%ld", (long)interstitialAd.meta.getECPM);
        [interstitialAd winNotice:price.integerValue];
    } else {
        QuMengLog(@"【媒体】插屏: 趣盟竞价失败，趣盟价格：%ld", (long)interstitialAd.meta.getECPM);
        [interstitialAd lossNotice:price.integerValue lossReason:QMLossReasonBaseFilter winBidder:channel];
        return;
    }
    [interstitialAd showInterstitialViewInRootViewController: Tool.topViewController];
}

- (void)qumeng_interstitialAdLoadFail:(QuMengInterstitialAd *)interstitialAd error:(NSError *)error {
    QuMengLog(@"【媒体】插屏: 请求失败");
    self.interstitialAd = nil;
    [MBProgressHUD showMessage:@"媒体插屏: 请求失败"];
}

- (void)qumeng_interstitialAdDidShow:(QuMengInterstitialAd *)interstitialAd {
    QuMengLog(@"【媒体】插屏: 曝光");
    [MBProgressHUD showMessage:@"媒体插屏: 曝光"];
}

- (void)qumeng_interstitialAdDidClick:(QuMengInterstitialAd *)interstitialAd {
    QuMengLog(@"【媒体】插屏: 点击");
    [MBProgressHUD showMessage:@"媒体插屏: 点击"];
}

- (void)qumeng_interstitialAdDidCloseOtherController:(QuMengInterstitialAd *)interstitialAd {
    QuMengLog(@"【媒体】插屏: 关闭落地页");
}

- (void)qumeng_interstitialAdDidClose:(QuMengInterstitialAd *)interstitialAd closeType:(QuMengInterstitialAdCloseType)type {
    self.interstitialAd = nil;
    QuMengLog(@"【媒体】插屏: 关闭广告");
}

/// 插屏广告视频播放开始
- (void)qumeng_interstitialAdDidStart:(QuMengInterstitialAd *)rewardedVideoAd {
    QuMengLog(@"【媒体】插屏: 视频播放开始");
}
/// 插屏广告视频播放暂停
- (void)qumeng_interstitialAdDidPause:(QuMengInterstitialAd *)rewardedVideoAd {
    QuMengLog(@"【媒体】插屏: 视频播放暂停");
}
/// 插屏广告视频播放继续
- (void)qumeng_interstitialAdDidResume:(QuMengInterstitialAd *)rewardedVideoAd {
    QuMengLog(@"【媒体】插屏: 视频播放继续");
}

- (void)qumeng_interstitialAdVideoDidPlayComplection:(QuMengInterstitialAd *)interstitialAd {
    QuMengLog(@"【媒体】插屏: 视频播放完成");
}

- (void)qumeng_interstitialAdVideoDidPlayFinished:(QuMengInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    QuMengLog(@"【媒体】插屏: 视频播放异常");
    [MBProgressHUD showMessage:@"媒体插屏: 视频播放异常"];
}
 

@end
