//
//  QuMengImage.h
//  QuMengAdSDK
//
//  Created by qusy on 2024/1/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuMengImage : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString *logoUrl;

/// 视频时长 视频有此字段
@property (nonatomic, assign) NSInteger duration;
/// 静音播放 默认 YES
@property (nonatomic, assign) BOOL mute;
/// 自动播放 默认 YES
@property (nonatomic, assign) BOOL auto_play;

@property (nonatomic, copy) NSString *text;

@end

NS_ASSUME_NONNULL_END
