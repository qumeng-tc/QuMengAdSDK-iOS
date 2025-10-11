//
//  QuMengAdMeta.h
//  QuMengAdSDK
//
//  Created by Donnie on 2024/10/31.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef  NSString QMWinBidder NS_TYPED_EXTENSIBLE_ENUM;
typedef  NSString QMLossReason NS_TYPED_EXTENSIBLE_ENUM;

// 胜出者媒体
extern QMWinBidder   *QMWinBidderCSJ;       // 穿山甲
extern QMWinBidder   *QMWinBidderGDT;       // 优量汇
extern QMWinBidder   *QMWinBidderKuaishou;  // 快手
extern QMWinBidder   *QMWinBidderBaidu;     // 百度
extern QMWinBidder   *QMWinBidderQumeng;    // 趣盟
extern QMWinBidder   *QMWinBidderOther;     // 其他家

// 竞价失败原因
extern QMLossReason   *QMLossReasonBaseFilter;   // 底价过滤
extern QMLossReason   *QMLossReasonLowBid;       // bid价格低于最高价
extern QMLossReason   *QMLossReasonBlacklist;    // 素材黑名单过滤
extern QMLossReason   *QMLossReasonCompetitor;   // 竞品过滤
extern QMLossReason   *QMLossReasonNoResponse;   // 在有效时间内，未返回广告
extern QMLossReason   *QMLossReasonOther;      // 其他

@interface QuMengAdMeta : NSObject

// Initializer with response dictionary
- (instancetype)initWithResponse:(NSDictionary<NSString *, id> *)response;

// Public properties
/**
 * 广告唯一id
 */
@property (nonatomic, readonly) NSString *getRequestId;

/**
 * 创意ID
 */
@property (nonatomic, readonly) NSString *getIdeaId;

/**
 * 广告价格(分)
 */
@property (nonatomic, readonly) NSInteger getECPM;

/**
 * 广告标题
 */
@property (nonatomic, readonly) NSString *getTitle;

/**
 * 广告描述
 */
@property (nonatomic, readonly) NSString *getDesc;

/**
 * 广告封面
 */
@property (nonatomic, readonly) NSString *logoUrl;

/**
 * 落地页地址
 */
@property (nonatomic, readonly) NSString *getLandingPageUrl;

/**
 * 广告交互类型
 * 1：落地页类型
 * 2：下载类型（包含拉新和拉活）
 * 3: 小程序
 * 4: 快应用
 */
@property (nonatomic, readonly) NSInteger getInteractionType;

/**
 * 广告事件交互标题
 */
@property (nonatomic, readonly) NSString *getInteractionTitle;

/**
 * 广告资源链接、单图或者视频
 */
@property (nonatomic, readonly) NSString *getMediaUrl;

/**
 * 广告资源视频静音
 */
@property (nonatomic, readonly) BOOL getMediaMute;

/**
 * 广告创意应用logo
 */
@property (nonatomic, readonly) NSString *getAppLogoUrl;

/**
 * 广告创意应用名称
 */
@property (nonatomic, readonly) NSString *getAppName;

/**
 * 广告创意应用包名
 */
@property (nonatomic, readonly) NSString *getAppPackageName;

/**
 * 广告六要素信息
 */
@property (nonatomic, readonly) NSDictionary<NSString *, id> *getAppInformation;

/**
 * 素材宽高
 */
@property (nonatomic, readonly) CGSize getMediaSize;

/**
 * 组图
 */
@property (nonatomic, readonly) NSArray<NSString *> *getExtUrls;

/**
 * 广告物料的类型
 * 1：小图
 * 2：大图
 * 3: 组图
 * 4：视频
 * 6: 开屏
 * 12: 激励视频
 */
@property (nonatomic, readonly) NSInteger getMaterialType;

/**
 * 视频播放时长
 */
@property (nonatomic, readonly) NSInteger getVideoDuration;

/**
 * 趣盟广告标识（无文字）
 */
- (NSString *)qmLogoUrl;

/**
 * 趣盟广告标识（有文字）
 */
- (NSString *)qmTextLogoUrl;

/**
 * 扩展信息
 */
@property (nonatomic, readonly) NSDictionary<NSString *, id> *getExtraInfo;


/**
 * UniversalLink
 */
@property (nonatomic, readonly) NSString *getUniversalLink;


/**
 * DeepLink
 */
@property (nonatomic, readonly) NSString *getDeepLink;

/**
 * DownloadUrl
 */
@property (nonatomic, readonly) NSString *getDownloadUrl;

@end

NS_ASSUME_NONNULL_END
