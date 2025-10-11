//
//  QuMengAdSDKManager.h
//  QuMengAdSDK
//
//  Created by qusy on 2023/12/29.
//

#import <Foundation/Foundation.h>
#import <QuMengAdSDK/QuMengAdSDKConfiguration.h>

typedef NS_ENUM(NSUInteger, QuMengAdSDKInitializationState) {
    QuMengAdSDKInitializationStateNotReady = 0,
    QuMengAdSDKInitializationStateReady = 1,
    QuMengAdSDKInitializationStateFailed = 2
};

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_subclassing_restricted))
@interface QuMengAdSDKManager : NSObject

/// 版本号
+ (NSString *)sdkVersion;

/// 小版本号
+ (NSString *)shortSdkVersion;

/// QMCD
+ (NSArray *)qmcds;

/// The  initialization state
+ (QuMengAdSDKInitializationState)sdkState;

/// 是否允许摇一摇/扭一扭（单设备纬度）
/// 默认：YES 允许
+ (void)setTwistSwitch:(BOOL)enabled;

/// The  initialization method
+ (void)setupSDKWith:(QuMengAdSDKConfiguration *)config;

/// 初始化 SDK
+ (void)setupSDKWith:(QuMengAdSDKConfiguration *)config completion:(void (^)(BOOL success, NSError *error))handler;

@end

NS_ASSUME_NONNULL_END
