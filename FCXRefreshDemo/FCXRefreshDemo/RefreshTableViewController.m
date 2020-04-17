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
#import "FCXRefreshDotAnimationHeaderView.h"
#import "FCXRefreshDotPathAnimationHeaderView.h"


static NSString *const RefreshCellReuseId = @"RefreshCellReuseId";
NSInteger PageCount = 20;
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
    
    _rows = PageCount;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:RefreshCellReuseId];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self addRefreshView];
    [self setupConfig];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
//    _refreshFooterView.loadMoreIgnoreContentSize = YES;
}

- (void)setupConfig {
    switch (_selectedRow) {
        case 0:
        {
            self.title = @"普通";
        }
            break;
        case 1:
        {//自动下拉刷新
            self.title = @"自动下拉刷新";
            [_refreshHeaderView autoRefresh];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(autoRefresh)];
        }
            break;
        case 2:
        {//自动加载更多
            self.title = @"自动上拉加载更多";
            _refreshFooterView.autoLoadMore = YES;
        }
            break;
        case 3:
        {
            self.title = @"上拉无更多数据";
        }
            break;
        case 4:
        {//显示百分比
            self.title = @"显示百分比";
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
            break;
        case 5:
        {//底部间隙
            self.title = @"底部间隙";
            _refreshFooterView.loadMoreBottomExtraSpace = 30;
        }
            break;
        case 6:
        {//自定义颜色
            self.title = @"自定义颜色";
            _refreshHeaderView.timeLabel.textColor = [UIColor redColor];
            _refreshHeaderView.statusLabel.textColor = [UIColor blueColor];
            _refreshFooterView.statusLabel.textColor = [UIColor magentaColor];
        }
            break;
        case 7:
        {//自定义文本
            self.title = @"自定义文本";
            _refreshHeaderView.normalStateText = @"normal";
            _refreshHeaderView.pullingStateText = @"pulling";
            _refreshHeaderView.loadingStateText = @"loading";
            
            _refreshFooterView.normalStateText = @"normal";
            _refreshFooterView.pullingStateText = @"pulling";
            _refreshFooterView.loadingStateText = @"loading";
            _refreshFooterView.noMoreDataStateText = @"NoData";
        }
            break;
        case 8:
        {//隐藏时间
            self.title = @"隐藏时间";
            _refreshHeaderView.arrowOffsetX = 35;
            [_refreshHeaderView hideTime];
        }
            break;
        case 9:
        {//隐藏状态和时间
            self.title = @"隐藏状态和时间";
            [_refreshHeaderView hideStatusAndTime];
            [_refreshFooterView hideStatusAndTime];
        }
            break;
        case 10:
        {//自定义动画
            self.title = @"圆点闪烁动画";
            [_refreshHeaderView removeFromSuperview];
            _refreshHeaderView = [[FCXRefreshDotAnimationHeaderView alloc] initWithFrame:CGRectMake(0, -FCXHandingOffsetHeight, self.tableView.frame.size.width, FCXHandingOffsetHeight)];
            _refreshHeaderView.backgroundColor = [UIColor clearColor];
            [self.tableView addSubview:_refreshHeaderView];
            __weak typeof(self) weakSelf = self;
            _refreshHeaderView.refreshHandler = ^(FCXRefreshBaseView *refreshView) {
                [weakSelf refreshAction];
            };
            [_refreshHeaderView hideStatusAndTime];
            [_refreshFooterView hideStatusAndTime];
        }
            break;
        case 11:
        {//自定义动画
            self.title = @"圆点轨迹动画";
            [_refreshHeaderView removeFromSuperview];
            _refreshHeaderView = [[FCXRefreshDotPathAnimationHeaderView alloc] initWithFrame:CGRectMake(0, -FCXHandingOffsetHeight, self.tableView.frame.size.width, FCXHandingOffsetHeight)];
            _refreshHeaderView.backgroundColor = [UIColor clearColor];
            [self.tableView addSubview:_refreshHeaderView];
            __weak typeof(self) weakSelf = self;
            _refreshHeaderView.refreshHandler = ^(FCXRefreshBaseView *refreshView) {
                [weakSelf refreshAction];
            };
            [_refreshHeaderView hideStatusAndTime];
            [_refreshFooterView hideStatusAndTime];
        }
            break;
        default:
            break;
    }
}

- (void)autoRefresh {
    [_refreshHeaderView autoRefresh];
}

- (void)refreshAction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _rows = PageCount;
        [self.tableView reloadData];
        [_refreshHeaderView endRefresh];
        if (_selectedRow == 3) {//刷新后把无更多数据的状态重置
            [_refreshFooterView resetNoMoreData];
        }
    });
}

- (void)loadMoreAction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _rows += PageCount;
        [self.tableView reloadData];
        if (_selectedRow == 3 && _rows >= 3 * PageCount) {//控制上拉加载最多3页
            [_refreshFooterView showNoMoreData];
        } else {
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
