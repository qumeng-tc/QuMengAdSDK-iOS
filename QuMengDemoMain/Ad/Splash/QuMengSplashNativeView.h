//
//  QMSplashWindow.h
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/26.
//

#import <UIKit/UIKit.h>
#import <QuMengAdSDK/QuMengAdSDK.h>

NS_ASSUME_NONNULL_BEGIN


@interface QuMengSplashNativeView : UIView

@property (nonatomic, strong) UIButton *skipBtn;
@property (nonatomic, strong) UIButton *actionBtn;
- (instancetype)initWithSplashNativeAd:(id)splashNativeAd;

@end

NS_ASSUME_NONNULL_END
