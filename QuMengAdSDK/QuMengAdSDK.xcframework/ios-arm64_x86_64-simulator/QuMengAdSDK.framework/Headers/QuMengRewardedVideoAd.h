//
//  QuMengRewardedVideoAd.h
//  QuMengAdSDK
//
//  Created by qusy on 2023/12/28.
//

#import <UIKit/UIKit.h>

#import <QuMengAdSDK/QuMengAdMeta.h>
#import <QuMengAdSDK/QuMengRetentionAlertInfo.h>

typedef NS_ENUM(NSUInteger, QuMengRewardedVideoAdCloseType) {
    QuMengRewardedVideoAdCloseTypeNormal = 0,
};

NS_ASSUME_NONNULL_BEGIN

@protocol QuMengRewardedVideoAdDelegate;

@interface QuMengRewardedVideoAd : NSObject

/// 栏位 ID
@property (nonatomic, copy, readonly, nonnull) NSString *slotID;

/// 每千次展示费用 单位：分
@property (nonatomic, assign, readonly) NSInteger ecpm;

/// 广告素材数据
@property (nonatomic, strong, readonly) QuMengAdMeta *meta;

/// 自定义挽留弹窗
@property (nonatomic, strong) QuMengRetentionAlertInfo *retentionInfo;

/// 广告事件代理
@property (nonatomic, weak) id<QuMengRewardedVideoAdDelegate> delegate;

/// 使用 controller present 落地页，默认使用广告 VC
@property (nonatomic, weak) UIViewController *viewController;

/// 初始化
/// @param slotID  栏位id
- (instancetype)initWithSlot:(NSString *)slotID;

/// 加载广告
- (void)loadAdData;

/// 展示广告
/// @param viewController 承载控制器
- (void)showRewardedVideoViewInRootViewController:(UIViewController *)viewController;

/// 竞价成功
/// - Parameter auctionSecondPrice: 竞价第二名价格，单位是分
- (void)winNotice:(NSInteger)auctionSecondPrice;

/**
 竞价失败
 @param auctionPrice 胜出者价格，单位分
 @param winBidder 胜出者对应媒体
        如果需要扩展，可以直接传入自定义字符串。
 @param lossReason 竞价失败原因
        如果需要扩展，可以直接传入自定义的字符串（建议字符串为 >1000 的数字）
 */
- (void)lossNotice:(NSInteger)auctionPrice
        lossReason:(QMLossReason  * _Nullable)lossReason
         winBidder:(QMWinBidder  * _Nullable)winBidder;

/// 是否有效 YES: 有效 NO: 无效
- (BOOL)isValid;

@end

@protocol QuMengRewardedVideoAdDelegate <NSObject>

@optional

/// 激励视频广告加载成功
/// - Parameter rewardedVideoAd: 激励视频
- (void)qumeng_rewardedVideoAdLoadSuccess:(QuMengRewardedVideoAd *)rewardedVideoAd;

/// 激励视频广告加载失败
/// - Parameters:
///   - rewardedVideoAd: 激励视频
///   - error: 错误信息
- (void)qumeng_rewardedVideoAdLoadFail:(QuMengRewardedVideoAd *)rewardedVideoAd error:(NSError *)error;

/// 激励视频广告曝光
/// - Parameter rewardedVideoAd: 激励视频
- (void)qumeng_rewardedVideoAdDidShow:(QuMengRewardedVideoAd *)rewardedVideoAd;

/// 激励视频广告点击
/// - Parameter rewardedVideoAd: 激励视频
- (void)qumeng_rewardedVideoAdDidClick:(QuMengRewardedVideoAd *)rewardedVideoAd;

/// 激励视频广告关闭
/// - Parameters:
///   - rewardedVideoAd: 激励视频
///   - type: 关闭类型
- (void)qumeng_rewardedVideoAdDidClose:(QuMengRewardedVideoAd *)rewardedVideoAd closeType:(QuMengRewardedVideoAdCloseType)type;

/// 激励视频广告激励完成
/// - Parameter rewardedVideoAd: 激励视频
- (void)qumeng_rewardedVideoAdDidRewarded:(QuMengRewardedVideoAd *)rewardedVideoAd;

/// 开始播放
/// - Parameter rewardedVideoAd: 激励视频
- (void)qumeng_rewardedVideoAdDidStart:(QuMengRewardedVideoAd *)rewardedVideoAd;

/// 播放暂停
/// - Parameter rewardedVideoAd: 激励视频
- (void)qumeng_rewardedVideoAdDidPause:(QuMengRewardedVideoAd *)rewardedVideoAd;

/// 回复播放
/// - Parameter rewardedVideoAd: 激励视频
- (void)qumeng_rewardedVideoAdDidResume:(QuMengRewardedVideoAd *)rewardedVideoAd;

/// 激励视频广告视频播放完成
/// - Parameters:
///   - rewardedVideoAd: 激励视频
///   - isRewarded: 是否获得奖励
- (void)qumeng_rewardedVideoAdVideoDidPlayComplection:(QuMengRewardedVideoAd *)rewardedVideoAd rewarded:(BOOL)isRewarded;

/// 激励视频广告视频播放结束
/// - Parameters:
///   - rewardedVideoAd: 激励视频
///   - error: 错误信息
///   - isRewarded: 是否获得奖励
- (void)qumeng_rewardedVideoAdVideoDidPlayFinished:(QuMengRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error rewarded:(BOOL)isRewarded;

@end

NS_ASSUME_NONNULL_END
