//
//  QuMengBaseDemoViewController.h
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import <UIKit/UIKit.h>

#import <Masonry/Masonry.h>

#import "MBProgressHUD+QuMengAD.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuMengBaseDemoViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *sourceArray;

@end

NS_ASSUME_NONNULL_END
