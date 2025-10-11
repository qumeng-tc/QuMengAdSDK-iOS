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
#import "ViewController.h"

#import <QuMengAdSDK/QuMengAdSDK.h>

@interface QuMengNativeDemoViewController ()<QuMengNativeAdDelegate>

@property (nonatomic, strong) NSMutableArray *nativeAds;
@property (nonatomic, strong) dispatch_group_t completionGroup;


@end

@implementation QuMengNativeDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[QuMengNativeSingleImageCell class] forCellReuseIdentifier:@"QuMengNativeSingleImageCell"];
    [self.tableView registerClass:[QuMengNativeAtlasImgeCell class] forCellReuseIdentifier:@"QuMengNativeAtlasImgeCell"];
    [self.tableView registerClass:[QuMengNativeVideoCell class] forCellReuseIdentifier:@"QuMengNativeVideoCell"];
    [self loadData:self.slot];
}

- (void)loadData:(NSString *)slotID  {
    self.nativeAds = @[
        [[QuMengNativeAd alloc] initWithSlot:slotID],
        [[QuMengNativeAd alloc] initWithSlot:slotID],
        [[QuMengNativeAd alloc] initWithSlot:slotID],
        [[QuMengNativeAd alloc] initWithSlot:slotID]
    ].mutableCopy;
    
    _completionGroup = dispatch_group_create();
    for (QuMengNativeAd *nativeAd in self.nativeAds) {
        dispatch_group_enter(_completionGroup);
        nativeAd.delegate = self;
        [nativeAd loadAdData];
    }
    
    __block NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 16; i ++) {
        [array addObject:[NSString stringWithFormat:@"Test Native AD: %d", i]];
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_group_notify(_completionGroup, dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        for (QuMengNativeAd *nativeAd in self.nativeAds) {
            nativeAd.delegate = strongSelf;
            NSInteger idx = [strongSelf.nativeAds indexOfObject:nativeAd];
            idx = idx * 4 + 1;
            [array insertObject:nativeAd atIndex:idx];
        }
        strongSelf.sourceArray = array;
        [strongSelf.tableView reloadData];
    });
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

// MARK: - QuMengNativeAdDelegate
/// 自渲染广告加载成功
- (void)qumeng_nativeAdLoadSuccess:(QuMengNativeAd *)nativeAd {
    // 检查广告有效性
    if (checkAdValid()) {
        [nativeAd isValid];
    }
    
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    QuMengLog(@"【媒体】自渲染%ld: 请求成功",(long)idx + 1);
    NSDictionary *auctionInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"setAuctionInfo"];
    QuMengLog(@"【媒体】自渲染: 竞价信息 %@", auctionInfo);
    
    NSString *channel = auctionInfo[@"channel"];
    NSString *price = auctionInfo[@"price"];
    if (nativeAd.meta.getECPM >= price.integerValue) {
        QuMengLog(@"【媒体】自渲染: 趣盟竞价成功，趣盟价格：%ld", (long)nativeAd.meta.getECPM);
        [nativeAd winNotice:price.integerValue];
    } else {
        QuMengLog(@"【媒体】自渲染: 趣盟竞价失败，趣盟价格：%ld", (long)nativeAd.meta.getECPM);
        [nativeAd lossNotice:price.integerValue lossReason:QMLossReasonBaseFilter winBidder:channel];
        [self.nativeAds removeObject: nativeAd];
    }    
    
    dispatch_group_leave(_completionGroup);
}

/// 自渲染广告加载失败
- (void)qumeng_nativeAdLoadFail:(QuMengNativeAd *)nativeAd error:(NSError *)error {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    QuMengLog(@"【媒体】自渲染%ld: 请求失败",(long)idx + 1);
    [self.nativeAds removeObject:nativeAd];
    dispatch_group_leave(_completionGroup);
}


- (void)qumeng_nativeAdDidShow:(QuMengNativeAd *)nativeAd {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    QuMengLog(@"【媒体】自渲染%ld: 曝光",(long)idx + 1);
    [MBProgressHUD showMessage:@"NativeAd: 曝光"];
}

- (void)qumeng_nativeAdDidClick:(QuMengNativeAd *)nativeAd {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    QuMengLog(@"【媒体】自渲染%ld: 点击",(long)idx + 1);
    [MBProgressHUD showMessage:@"NativeAd: 点击"];
}

- (void)qumeng_nativeAdDidCloseOtherController:(QuMengNativeAd *)nativeAd {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    QuMengLog(@"【媒体】自渲染%ld: 关闭落地页",(long)idx + 1);
    [MBProgressHUD showMessage:@"NativeAd: 关闭落地页"];
}

/// 自渲染视频播放开始
- (void)qumeng_nativeAdDidStart:(QuMengNativeAd *)nativeAd {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    QuMengLog(@"【媒体】自渲染%ld: 视频播放开始",(long)idx + 1);
}

/// 自渲染视频播放暂停
- (void)qumeng_nativeAdDidPause:(QuMengNativeAd *)nativeAd {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    QuMengLog(@"【媒体】自渲染%ld: 视频播放暂停",(long)idx + 1);
}

/// 自渲染视频播放继续
- (void)qumeng_nativeAdDidResume:(QuMengNativeAd *)nativeAd {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    QuMengLog(@"【媒体】自渲染%ld: 视频播放继续",(long)idx + 1);
}

/// 自渲染视频播放完成
- (void)qumeng_nativeAdVideoDidPlayComplection:(QuMengNativeAd *)nativeAd {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    QuMengLog(@"【媒体】自渲染%ld: 视频播放完成",(long)idx + 1);

}

/// 自渲染视频播放异常
- (void)qumeng_nativeAdVideoDidPlayFinished:(QuMengNativeAd *)nativeAd didFailWithError:(NSError *)error {
    NSInteger idx = [self.nativeAds indexOfObject:nativeAd];
    QuMengLog(@"【媒体】自渲染%ld: 视频播放结束",(long)idx + 1);
}

@end
