//
//  UIColor+QuMengAD.h
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (QMAD)

+ (UIColor *)qumeng_colorWithHex:(nonnull NSString *)hex;
- (NSString *)qumeng_hexString;

+ (UIImage *)qumeng_imageWith:(NSString *)hexString size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
