//
//  QuMengSplashAd.h
//  QuMengAdSDK
//
//  Created by qusy on 2023/12/28.
//

#import <UIKit/UIKit.h>
#import <QuMengAdSDK/QuMengAdMeta.h>

typedef NS_ENUM(NSUInteger, QuMengSplashAdCloseType) {
    QuMengSplashAdCloseTypeNormal = 0,
};


NS_ASSUME_NONNULL_BEGIN

@protocol QuMengSplashAdDelegate;

@interface QuMengSplashAd : NSObject

@property (nonatomic, weak) id<QuMengSplashAdDelegate> delegate;

/// 栏位id
@property (nonatomic, copy, readonly, nonnull) NSString *slotID;

/// 使用 controller present 落地页，默认使用广告 VC
@property (nonatomic, weak) UIViewController *viewController;

/// 广告点击自动关闭
@property (nonatomic) BOOL adClickToCloseAutomatically;

/// 广告物料
@property (nonatomic, strong) QuMengAdMeta * meta;

/// 初始化
/// @param slotID  栏位id
- (instancetype)initWithSlot:(NSString *)slotID;

/// 加载开屏广告
- (void)loadAdData;

/// 展示开屏广告，自定义底部logo
- (void)showSplashViewController:(UIViewController *)controller withBottomView:(UIView *)bottomView;

/// 展示开屏广告
- (void)showSplashViewController:(UIViewController *)controller;

/// 展示开屏广告，自定义底部logo
- (void)showSplashWindow:(UIWindow *)window withBottomView:(UIView *)bottomView;

/// 展示开屏广告
- (void)showSplashWindow:(UIWindow *)window;

/// 关闭开屏广告
- (void)closeSplashAdWithCompletion:(void (^ __nullable)(void))completion;

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

@protocol QuMengSplashAdDelegate <NSObject>

@optional

/// 开屏广告加载成功
- (void)qumeng_splashAdLoadSuccess:(QuMengSplashAd *)splashAd;

/// 开屏广告加载失败
- (void)qumeng_splashAdLoadFail:(QuMengSplashAd *)splashAd error:(NSError *)error;

/// 开屏广告渲染成功
- (void)qumeng_splashAdRenderSuccess:(QuMengSplashAd *)splashAd;

/// 开屏广告渲染失败
- (void)qumeng_splashAdRenderFail:(QuMengSplashAd *)splashAd error:(NSError *)error;

/// 开屏广告曝光
- (void)qumeng_splashAdDidShow:(QuMengSplashAd *)splashAd;

/// 开屏广告点击
- (void)qumeng_splashAdDidClick:(QuMengSplashAd *)splashAd;

/// 开屏广告关闭
- (void)qumeng_splashAdDidClose:(QuMengSplashAd *)splashAd closeType:(QuMengSplashAdCloseType)type;

// 开屏广告展示失败
- (void)qumeng_splashAdShowFail:(QuMengSplashAd *)splashAd error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
