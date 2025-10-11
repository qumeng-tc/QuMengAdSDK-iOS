//
//  QMRewardedVideoDemoViewController.h
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import <UIKit/UIKit.h>
#import <QuMengAdSDK/QuMengAdSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuMengRewardedVideoConf : NSObject

@property (nonatomic, copy) NSString *slot;
@property (nonatomic, strong) QuMengRetentionAlertInfo *info;

@end

NS_ASSUME_NONNULL_END
