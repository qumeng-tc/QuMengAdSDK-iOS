//
//  QMInterstitialDemoViewController.h
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import <UIKit/UIKit.h>
#import "QuMengBaseConf.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QuMengSplashAdConfDelegate <NSObject>
@optional
// 关闭开屏
- (void)splashAdDidClose;
@end

@interface QuMengSplashAdConf : NSObject <QuMengBaseConf>
@property (nonatomic, weak) id<QuMengSplashAdConfDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
