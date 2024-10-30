//
//  QuMengBaseDemoViewController.m
//  QuMengAdSDKDemo
//
//  Created by qusy on 2024/2/5.
//

#import "QuMengBaseDemoViewController.h"
#import <Masonry.h>
#import "UIColor+QuMengAD.h"

@interface QuMengBaseDemoViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation QuMengBaseDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#F5F5F5"];
    self.sourceArray = @[];
    
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(0);
    }];
}

// MARK: - tableView delegate && dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = NSStringFromClass([UITableViewCell class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (BOOL)shouldAutorotate {
    return NO;
}

// MARK: - lazy
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        table.dataSource = self;
        table.delegate = self;
        table.backgroundColor = [UIColor colorWithHex:@"#F5F5F5"];
        table.separatorColor = [UIColor colorWithHex:@"#CCCCCC"];
        table.separatorInset = UIEdgeInsetsZero;
        table.sectionHeaderHeight = 40;
        if (@available(iOS 15.0, *)) {
            table.sectionHeaderTopPadding = 0;
            
        }
        _tableView = table;
    }
    return _tableView;
}

@end
