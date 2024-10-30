//
//  QuMengNativeCell.h
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/20.
//

#import <UIKit/UIKit.h>
#import <QuMengAdSDK/QuMengAdSDK-Swift.h>
//#import <AnyThinkNative/AnyThinkNative.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuMengNativeCell : UITableViewCell
@property (nonatomic, strong) QuMengNativeAd *nativeAd;
- (void)refreshWithData:(QuMengNativeAd *)nativeAd; 

// TopOn 数据展示
//- (void)refreshWithOffer:(ATNativeAdOffer *)offer;

@end

NS_ASSUME_NONNULL_END
