//
//  QuMengSplashContainerViewController.h
//  QuMengAdSDK
//
//  Created by xusheng on 2024/11/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuMengSplashContainerViewController : UIViewController
@property (nonatomic, copy) NSString *slot;
- (void)loadSplashAd;
@end

NS_ASSUME_NONNULL_END
