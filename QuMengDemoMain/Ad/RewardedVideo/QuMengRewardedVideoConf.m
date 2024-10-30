//
//  QMRewardedVideoDemoViewController.m
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import <QuMengAdSDK/QuMengAdSDK-Swift.h>
#import <Masonry.h>

#import "QuMengRewardedVideoConf.h"
#import "MBProgressHUD+QuMengAD.h"
#import "QuMengBaseConf.h"
#import "ViewController.h"

@interface QuMengRewardedVideoConf ()<QuMengRewardedVideoAdDelegate, QuMengBaseConf>

@property (nonatomic, strong) QuMengRewardedVideoAd *rewardedVideoAd;

@end

@implementation QuMengRewardedVideoConf

- (void)qumeng_loadAd:(NSDictionary *)item {
    NSString *slotID = item[@"slot"];
    _rewardedVideoAd = [[QuMengRewardedVideoAd alloc] initWithSlot:slotID];
    _rewardedVideoAd.retentionInfo = self.info;
    /// 广告点击自动关闭，不需要可以不传
    _rewardedVideoAd.adClickToCloseAutomatically = adClickToCloseAutomatically();
    _rewardedVideoAd.delegate = self;
    [_rewardedVideoAd loadAdData];
}

// MARK: - QuMengInterstitialAdDelegate
- (void)qumeng_rewardedVideoAdLoadSuccess:(QuMengRewardedVideoAd *)rewardedVideoAd {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [rewardedVideoAd showRewardedVideoViewInRootViewController:keyWindow.rootViewController];
}

- (void)qumeng_rewardedVideoAdLoadFail:(QuMengRewardedVideoAd *)rewardedVideoAd error:(NSError *)error {
    NSLog(@"【媒体】激励视频: 请求失败");
    [MBProgressHUD showMessage:@"媒体激励视频: 请求失败"];
}

- (void)qumeng_rewardedVideoAdDidShow:(QuMengRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"【媒体】激励视频: 曝光");
}

- (void)qumeng_rewardedVideoAdDidClick:(QuMengRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"【媒体】激励视频: 点击");
}

- (void)qumeng_rewardedVideoAdDidRewarded:(QuMengRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"【媒体】激励视频: 激励成功已获得奖励");
}

- (void)qumeng_rewardedVideoAdDidCloseOtherController:(QuMengRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"【媒体】激励视频: 关闭落地页");
}

- (void)qumeng_rewardedVideoAdDidClose:(QuMengRewardedVideoAd *)rewardedVideoAd closeType:(QuMengRewardedVideoAdCloseType)type {
    NSLog(@"【媒体】激励视频: 关闭广告");
}

/// 激励视频广告播放开始
- (void)qumeng_rewardedVideoAdDidStart:(QuMengRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"【媒体】激励视频: 播放开始");
}

/// 激励视频广告播放暂停
- (void)qumeng_rewardedVideoAdDidPause:(QuMengRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"【媒体】激励视频: 播放暂停");
}
/// 激励视频广告播放继续
- (void)qumeng_rewardedVideoAdDidResume:(QuMengRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"【媒体】激励视频: 播放继续");
}

- (void)qumeng_rewardedVideoAdVideoDidPlayComplection:(QuMengRewardedVideoAd *)rewardedVideoAd rewarded:(BOOL)isRewarded {
    NSLog(@"【媒体】激励视频: 视频播放完成");
}

- (void)qumeng_rewardedVideoAdVideoDidPlayFinished:(QuMengRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error rewarded:(BOOL)isRewarded {
    NSLog(@"【媒体】激励视频: 视频播放失败");
    [MBProgressHUD showMessage:@"媒体激励视频: 视频播放失败"];
}

@end
