//
//  QMRewardedVideoDemoViewController.m
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import <QuMengAdSDK/QuMengAdSDK.h>
#import <Masonry/Masonry.h>

#import "QuMengRewardedVideoConf.h"
#import "QuMengBaseConf.h"
#import "ViewController.h"
#import "Tool.h"

#import "MBProgressHUD+QuMengAD.h"

@interface QuMengRewardedVideoConf ()<QuMengRewardedVideoAdDelegate, QuMengBaseConf>

@property (nonatomic, strong) QuMengRewardedVideoAd *rewardedVideoAd;

@end

@implementation QuMengRewardedVideoConf

- (void)qumeng_loadAd:(NSDictionary *)item {
    NSString *slotID = item[@"slot"];
    _rewardedVideoAd = [[QuMengRewardedVideoAd alloc] initWithSlot:slotID];
    _rewardedVideoAd.retentionInfo = self.info;
    _rewardedVideoAd.delegate = self;
    [_rewardedVideoAd loadAdData];
}

// MARK: - QuMengInterstitialAdDelegate
- (void)qumeng_rewardedVideoAdLoadSuccess:(QuMengRewardedVideoAd *)rewardedVideoAd {
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    //    当前页面如果是present vc 使用keyWindow.rootViewController会失效
    //    [rewardedVideoAd showRewardedVideoViewInRootViewController:keyWindow.rootViewController];
    
    // 检查广告有效性
    if (checkAdValid()) {
        [rewardedVideoAd isValid];
    }
    
    NSDictionary *auctionInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"setAuctionInfo"];
    QuMengLog(@"【媒体】激励视频:: 竞价信息 %@", auctionInfo);
    
    NSString *channel = auctionInfo[@"channel"];
    NSString *price = auctionInfo[@"price"];
    if (rewardedVideoAd.meta.getECPM >= price.integerValue) {
        QuMengLog(@"【媒体】激励视频:: 趣盟竞价成功，趣盟价格：%ld", (long)rewardedVideoAd.meta.getECPM);
        [rewardedVideoAd winNotice:price.integerValue];
    } else {
        QuMengLog(@"【媒体】激励视频:: 趣盟竞价失败，趣盟价格：%ld", (long)rewardedVideoAd.meta.getECPM);
        [rewardedVideoAd lossNotice:price.integerValue lossReason:QMLossReasonBaseFilter winBidder:channel];
        return;
    }
    
    [rewardedVideoAd showRewardedVideoViewInRootViewController:Tool.topViewController];
}

- (void)qumeng_rewardedVideoAdLoadFail:(QuMengRewardedVideoAd *)rewardedVideoAd error:(NSError *)error {
    QuMengLog(@"【媒体】激励视频: 请求失败");
    [MBProgressHUD showMessage:@"媒体激励视频: 请求失败"];
}

- (void)qumeng_rewardedVideoAdDidShow:(QuMengRewardedVideoAd *)rewardedVideoAd {
    QuMengLog(@"【媒体】激励视频: 曝光");
    [MBProgressHUD showMessage:@"媒体激励视频: 曝光"];
}

- (void)qumeng_rewardedVideoAdDidClick:(QuMengRewardedVideoAd *)rewardedVideoAd {
    QuMengLog(@"【媒体】激励视频: 点击");
    [MBProgressHUD showMessage:@"媒体激励视频: 点击"];
}

- (void)qumeng_rewardedVideoAdDidRewarded:(QuMengRewardedVideoAd *)rewardedVideoAd {
    QuMengLog(@"【媒体】激励视频: 激励成功已获得奖励");
    [MBProgressHUD showMessage:@"激励成功已获得奖励"];
}

- (void)qumeng_rewardedVideoAdDidCloseOtherController:(QuMengRewardedVideoAd *)rewardedVideoAd {
    QuMengLog(@"【媒体】激励视频: 关闭落地页");
}

- (void)qumeng_rewardedVideoAdDidClose:(QuMengRewardedVideoAd *)rewardedVideoAd closeType:(QuMengRewardedVideoAdCloseType)type {
    QuMengLog(@"【媒体】激励视频: 关闭广告");
    self.rewardedVideoAd = nil;
}

/// 激励视频广告播放开始
- (void)qumeng_rewardedVideoAdDidStart:(QuMengRewardedVideoAd *)rewardedVideoAd {
    QuMengLog(@"【媒体】激励视频: 播放开始");
}

/// 激励视频广告播放暂停
- (void)qumeng_rewardedVideoAdDidPause:(QuMengRewardedVideoAd *)rewardedVideoAd {
    QuMengLog(@"【媒体】激励视频: 播放暂停");
}
/// 激励视频广告播放继续
- (void)qumeng_rewardedVideoAdDidResume:(QuMengRewardedVideoAd *)rewardedVideoAd {
    QuMengLog(@"【媒体】激励视频: 播放继续");
}

- (void)qumeng_rewardedVideoAdVideoDidPlayComplection:(QuMengRewardedVideoAd *)rewardedVideoAd rewarded:(BOOL)isRewarded {
    QuMengLog(@"【媒体】激励视频: 视频播放完成");
}

- (void)qumeng_rewardedVideoAdVideoDidPlayFinished:(QuMengRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error rewarded:(BOOL)isRewarded {
    QuMengLog(@"【媒体】激励视频: 视频播放失败");
    [MBProgressHUD showMessage:@"媒体激励视频: 视频播放失败"];
}

@end
