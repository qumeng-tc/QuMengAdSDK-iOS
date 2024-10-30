//
//  UIColor+QuMengAD.m
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import "UIColor+QuMengAD.h"

@implementation UIColor (QMAD)

+ (UIColor *)colorWithHex:(nonnull NSString *)hex {
    
    NSString *hexS = hex;
    UIColor *color = [UIColor clearColor];
    
    if ([hexS hasPrefix:@"#"]) hexS = [hexS stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if ([hexS hasPrefix:@"0x"]) hexS = [hexS stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    
    hexS = [hexS uppercaseString];
    
    // 非 RGB、RRGGBB、AARRGGBB，返回透明色
    if ((hexS.length != 3) && (hexS.length != 6) && (hexS.length != 8)) return color;
    
    // 3位处理成6位
    if (hexS.length == 3) {
        
        NSString *R = [hexS substringWithRange:NSMakeRange(0, 1)];
        NSString *G = [hexS substringWithRange:NSMakeRange(1, 1)];
        NSString *B = [hexS substringWithRange:NSMakeRange(2, 1)];
        hexS = [NSString stringWithFormat:@"%@%@%@%@%@%@", R, R, G, G, B, B];
    }

    // 6位处理成8位
    if (hexS.length == 6) hexS = [@"FF" stringByAppendingFormat:@"%@", hexS];
    
    NSRange range = NSMakeRange(0, 2);
    unsigned int alpha = 255, red = 0, green = 0, blue = 0;
    
    while (range.location < 8) {
        
        unsigned int *res = &alpha;
        if (range.location == 2) {
            res = &red;
        } else if (range.location == 4) {
            res = &green;
        } else if (range.location == 6) {
            res = &blue;
        }
        [[NSScanner scannerWithString:[hexS substringWithRange:range]] scanHexInt:res];
        range.location += 2;
    }
    
    color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha/255.0];
    
    return color;
}

- (NSString *)hexString {
    
    if (!self) return nil;
    
    CGColorRef colorRef = self.CGColor;
    if (CGColorGetNumberOfComponents(colorRef) < 4) {
        
        const CGFloat *components = CGColorGetComponents(colorRef);
        colorRef = [UIColor colorWithRed:components[0] green:components[0] blue:components[0] alpha:components[1]].CGColor;
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(colorRef)) != kCGColorSpaceModelRGB) return @"#FFFFFFFF";
    
    const CGFloat *value = CGColorGetComponents(colorRef);
    CGFloat alpha = CGColorGetAlpha(colorRef);
    CGFloat red = 1.0, green = 1.0, blue = 1.0;
    
    red = roundf(value[0] * 255.0);
    green = roundf(value[1] * 255.0);
    blue = roundf(value[2] * 255.0);
    alpha = roundf(alpha * 255.0);
    
    uint hex = ((uint)alpha << 24) | ((uint)red << 16) | ((uint)green << 8) | ((uint)blue);
    NSString *string = [[NSString stringWithFormat:@"%08x", hex] uppercaseString];
    
    return [NSString stringWithFormat:@"#%@", string];
}

+ (UIImage *)imageWith:(NSString *)hexString size:(CGSize)size {
    UIColor *color = [self colorWithHex:hexString];
    if (!color || size.width <= 0 || size.height <= 0)
        return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
