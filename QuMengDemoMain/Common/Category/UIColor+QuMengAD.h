//
//  UIColor+QuMengAD.h
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (QMAD)

+ (UIColor *)colorWithHex:(nonnull NSString *)hex;
- (NSString *)hexString;

+ (UIImage *)imageWith:(NSString *)hexString size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
