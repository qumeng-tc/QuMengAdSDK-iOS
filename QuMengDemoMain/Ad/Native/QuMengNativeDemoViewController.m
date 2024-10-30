//
//  QuMengNativeDemoViewController.m
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import "QuMengNativeDemoViewController.h"
#import "QuMengNativeSingleImageCell.h"
#import "QuMengNativeAtlasImgeCell.h"
#import "QuMengNativeVideoCell.h"
#import <QuMengAdSDK/QuMengAdSDK-Swift.h>
@interface QuMengNativeDemoViewController ()<QuMengNativeAdDelegate, QuMengNativeAdRelatedViewDelegate>

@property (nonatomic, strong) NSArray *nativeAds;

@property (nonatomic, strong) dispatch_semaphore_t lock;

@end

@implementation QuMengNativeDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lock = dispatch_semaphore_create(1);
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 16; i ++) {
        [array addObject:[NSString stringWithFormat:@"Test Native AD: %d", i]];
    }
    self.sourceArray = [array copy];
    
    [self.tableView registerClass:[QuMengNativeSingleImageCell class] forCellReuseIdentifier:@"QuMengNativeSingleImageCell"];
    [self.tableView registerClass:[QuMengNativeAtlasImgeCell class] forCellReuseIdentifier:@"QuMengNativeAtlasImgeCell"];
    [self.tableView registerClass:[QuMengNativeVideoCell class] forCellReuseIdentifier:@"QuMengNativeVideoCell"];
    
    NSMutableArray *nativeAds = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        QuMengNativeAd *nativeAd = [[QuMengNativeAd alloc] initWithSlot:self.slot];
        nativeAd.delegate = self;
        [nativeAds addObject:nativeAd];
    }
    self.nativeAds = [nativeAds copy];
    
    for (QuMengNativeAd *nativeAd in self.nativeAds) {
        [nativeAd loadAdData];
    }
}

// MARK: - QuMengNativeAdDelegate
- (void)qumeng_nativeAdLoadSuccess:(QuMengNativeAd *)nativeAd {
    
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSMutableArray *array = [self.sourceArray mutableCopy];
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    idx = idx * 4 + 1;
    [array insertObject:nativeAd atIndex:idx];
    self.sourceArray = [array copy];
    [self.tableView reloadData];
    dispatch_semaphore_signal(_lock);
}

- (void)qumeng_nativeAdLoadFail:(QuMengNativeAd *)nativeAd error:(NSError *)error {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    NSLog(@"【媒体】自渲染%ld: 请求失败",(long)idx + 1);
}

- (void)qumeng_nativeAdDidShow:(QuMengNativeAd *)nativeAd {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    NSLog(@"【媒体】自渲染%ld: 曝光",(long)idx + 1);
}

- (void)qumeng_nativeAdDidClick:(QuMengNativeAd *)nativeAd {
    [MBProgressHUD showMessage:@"NativeAd: 点击"];
}

- (void)qumeng_nativeAdDidCloseOtherController:(QuMengNativeAd *)nativeAd {
    [MBProgressHUD showMessage:@"NativeAd: 关闭落地页"];
}

// MARK: - tableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id value = self.sourceArray[indexPath.item];
    if ([value isKindOfClass:[QuMengNativeAd class]]) {
        QuMengNativeAd *nativeAd = value;
        if (nativeAd.meta.getMaterialType == 3) {
            QuMengNativeAtlasImgeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuMengNativeAtlasImgeCell" forIndexPath:indexPath];
            [cell refreshWithData:nativeAd];
            return cell;
        } else if (nativeAd.meta.getMaterialType == 4) {
            QuMengNativeVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuMengNativeVideoCell" forIndexPath:indexPath];
            [cell refreshWithData:nativeAd];
            cell.nativeAd.relatedView.delegate = self;
            return cell;
        } else {
            QuMengNativeSingleImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuMengNativeSingleImageCell" forIndexPath:indexPath];
            [cell refreshWithData:nativeAd];
            return cell;
        }
    } else {
        NSString *cellID = NSStringFromClass([UITableViewCell class]);
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text = value;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id value = self.sourceArray[indexPath.item];
    if ([value isKindOfClass:[QuMengNativeAd class]]) {
        QuMengNativeAd *nativeAd = value;
        if (nativeAd.meta.getMaterialType == 3) {
            return 180;
        } else {
            return 230;
        }
    }
    return 160;
}

/// 插屏广告视频播放开始
- (void)qumeng_nativeAdRelatedViewDidStart:(QuMengNativeAdRelatedView *)nativeAdRelatedView {
    
    NSInteger idx = [self.nativeAds indexOfObject:nativeAdRelatedView.nativeAd];
    NSLog(@"【媒体】自渲染%ld: 视频播放开始",(long)idx + 1);
}
/// 插屏广告视频播放暂停
- (void)qumeng_nativeAdRelatedViewDidPause:(QuMengNativeAdRelatedView *)nativeAdRelatedView {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAdRelatedView.nativeAd];
    NSLog(@"【媒体】自渲染%ld: 视频播放暂停",(long)idx + 1);
}
/// 插屏广告视频播放继续
- (void)qumeng_nativeAdRelatedViewDidResume:(QuMengNativeAdRelatedView *)nativeAdRelatedView {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAdRelatedView.nativeAd];
    NSLog(@"【媒体】自渲染%ld: 视频播放继续",(long)idx + 1);
}
/// 插屏广告视频播放完成
- (void)qumeng_nativeAdRelatedViewDidPlayComplection:(QuMengNativeAdRelatedView *)nativeAdRelatedView {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAdRelatedView.nativeAd];
    NSLog(@"【媒体】自渲染%ld: 视频播放完成",(long)idx + 1);
}
/// 插屏广告视频播放异常
- (void)qumeng_nativeAdRelatedViewDidPlayFinished:(QuMengNativeAdRelatedView *)nativeAdRelatedView didFailWithError:(NSError *)error {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAdRelatedView.nativeAd];
    NSLog(@"【媒体】自渲染%ld: 视频播放结束",(long)idx + 1);
}

@end
