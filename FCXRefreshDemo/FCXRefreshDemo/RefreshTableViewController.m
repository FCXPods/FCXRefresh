//
//  RefreshTableViewController.m
//  FCXRefreshDemo
//
//  Created by 冯 传祥 on 2017/6/30.
//  Copyright © 2017年 冯 传祥. All rights reserved.
//

#import "RefreshTableViewController.h"
#import "UIScrollView+FCXRefresh.h"
#import "FCXRefreshHeaderView.h"
#import "FCXRefreshFooterView.h"


static NSString *const RefreshCellReuseId = @"RefreshCellReuseId";

@interface RefreshTableViewController ()
{
    FCXRefreshHeaderView *_refreshHeaderView;
    FCXRefreshFooterView *_refreshFooterView;
    NSInteger _rows;
}

@property (nonatomic, strong) FCXRefreshFooterView *refreshFooterView;


@end

@implementation RefreshTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FCXRefresh";
    
    _rows = 20;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:RefreshCellReuseId];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self addRefreshView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_selectedRow == 1) {//自动下拉刷新
        [_refreshHeaderView autoRefresh];
    }
}

- (void)addRefreshView {
    __weak typeof(self) weakSelf = self;

    //下拉刷新
    _refreshHeaderView = [self.tableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshAction];
    }];
    
    //上拉加载更多
    _refreshFooterView = [self.tableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf loadMoreAction];
    }];
    
    //自动刷新
    if (_selectedRow == 2) {
        _refreshFooterView.autoLoadMore = YES;
    }
    
    //显示百分比
    if (_selectedRow == 4) {
        
        UILabel *headerPercentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        headerPercentLabel.textAlignment = NSTextAlignmentCenter;
        headerPercentLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        headerPercentLabel.layer.borderWidth = .5;
        self.tableView.tableHeaderView = headerPercentLabel;
        
        UILabel *footerPercentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        footerPercentLabel.textAlignment = NSTextAlignmentCenter;
        footerPercentLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        footerPercentLabel.layer.borderWidth = .5;
        self.tableView.tableFooterView = footerPercentLabel;
        
        headerPercentLabel.text = footerPercentLabel.text = @"0%";

        _refreshHeaderView.pullingPercentHandler = ^(CGFloat pullingPercent) {
            headerPercentLabel.text = [NSString stringWithFormat:@"%.2f%%", pullingPercent * 100];
        };
        
        _refreshFooterView.pullingPercentHandler = ^(CGFloat pullingPercent) {
            footerPercentLabel.text = [NSString stringWithFormat:@"%.2f%%", pullingPercent * 100];
        };
    }
}


- (void)refreshAction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _rows = 20;
        [self.tableView reloadData];
        [_refreshHeaderView endRefresh];
    });
}

- (void)loadMoreAction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _rows += 20;
        [self.tableView reloadData];
        if (_selectedRow == 3 && _rows >= 40) {//控制上拉加载最多个数为30
            [_refreshFooterView showNoMoreData];
        }else {
            [_refreshFooterView endRefresh];
        }
    });
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RefreshCellReuseId forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行", (long)indexPath.row];
    
    return cell;
}

@end
