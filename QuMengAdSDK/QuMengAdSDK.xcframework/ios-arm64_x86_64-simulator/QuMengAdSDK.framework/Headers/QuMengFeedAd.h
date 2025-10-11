//
//  QuMengFeedAd.h
//  QuMengAdSDK
//
//  Created by qusy on 2024/1/16.
//

#import <UIKit/UIKit.h>

#import <QuMengAdSDK/QuMengAdMeta.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QuMengFeedAdDelegate;

@interface QuMengFeedAd : NSObject

@property (nonatomic, copy, readonly, nonnull) NSString *slotID;
@property (nonatomic, strong, readonly, nullable) UIView *feedView;
/// 自定义尺寸
@property (nonatomic, assign)CGSize customSize;

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong, readonly, nullable) QuMengAdMeta *meta;

@property (nonatomic, weak) id<QuMengFeedAdDelegate> delegate;

/// 初始化
/// @param slotID  栏位id
- (instancetype)initWithSlot:(NSString *)slotID;

/// 加载广告
- (void)loadAdData;

/// 获取广告高度
- (CGFloat)handleFeedAdHeight;

/// 竞价成功
/// - Parameter auctionSecondPrice: 竞价第二名价格，单位是分
- (void)winNotice:(NSInteger)auctionSecondPrice;

/**
 竞价失败
 @param auctionPrice 胜出者价格，单位分
 @param winBidder 胜出者对应媒体
        如果需要扩展，可以直接传入自定义字符串
 @param lossReason 竞价失败原因
        如果需要扩展，可以直接传入自定义的字符串（建议字符串为 >1000 的数字）
 */
- (void)lossNotice:(NSInteger)auctionPrice
        lossReason:(QMLossReason  * _Nullable)lossReason
         winBidder:(QMWinBidder  * _Nullable)winBidder;

/// 是否有效 YES: 有效 NO: 无效
- (BOOL)isValid;

@end

@protocol QuMengFeedAdDelegate <NSObject>

@optional

/// 信息流广告加载成功
- (void)qumeng_feedAdLoadSuccess:(QuMengFeedAd *)feedAd;

/// 信息流广告加载失败
- (void)qumeng_feedAdLoadFail:(QuMengFeedAd *)feedAd error:(NSError *)error;

/// 信息流广告曝光
- (void)qumeng_feedAdDidShow:(QuMengFeedAd *)feedAd;

/// 信息流广告点击
- (void)qumeng_feedAdDidClick:(QuMengFeedAd *)feedAd;

/// 信息流广告关闭
- (void)qumeng_feedAdDidClose:(QuMengFeedAd *)feedAd;

/// 落地页关闭
- (void)qumeng_feedAdDidCloseOtherController:(QuMengFeedAd *)feedAd;

/// 信息流视频播放开始
- (void)qumeng_feedAdDidStart:(QuMengFeedAd *)feedAd;

/// 信息流视频播放暂停
- (void)qumeng_feedAdDidPause:(QuMengFeedAd *)feedAd;

/// 信息流视频播放继续
- (void)qumeng_feedAdDidResume:(QuMengFeedAd *)feedAd;

/// 信息流视频播放完成
- (void)qumeng_feedAdVideoDidPlayComplection:(QuMengFeedAd *)feedAd;

/// 信息流视频播放异常
- (void)qumeng_feedAdVideoDidPlayFinished:(QuMengFeedAd *)feedAd didFailWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
