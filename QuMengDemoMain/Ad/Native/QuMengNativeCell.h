//
//  QuMengNativeCell.h
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/20.
//

#import <UIKit/UIKit.h>

#import <QuMengAdSDK/QuMengAdSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuMengNativeCell : UITableViewCell

@property (nonatomic, strong) UIButton *actionBtn;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) QuMengNativeAd *nativeAd;

@property (nonatomic, strong) QuMengNativeAdSlideView *slideView;

- (void)refreshWithData:(QuMengNativeAd *)nativeAd;

@end

NS_ASSUME_NONNULL_END
