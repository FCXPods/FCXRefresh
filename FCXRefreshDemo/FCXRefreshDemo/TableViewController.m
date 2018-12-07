//
//  TableViewController.m
//  FCXRefreshDemo
//
//  Created by 冯 传祥 on 2017/6/30.
//  Copyright © 2017年 冯 传祥. All rights reserved.
//

#import "TableViewController.h"
#import "RefreshTableViewController.h"

static NSString *const CellReuseId = @"cellReuseId";

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上下拉刷新";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellReuseId];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseId forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"上下拉刷新（普通）";
            break;
        case 1:
            cell.textLabel.text = @"上下拉刷新（自动下拉加载）";
            break;
        case 2:
            cell.textLabel.text = @"上下拉刷新（自动上拉加载）";
            break;
        case 3:
            cell.textLabel.text = @"上下拉刷新（上拉无更多数据）";
            break;
        case 4:
            cell.textLabel.text = @"上下拉刷新（显示百分比）";
            break;
        case 5:
            cell.textLabel.text = @"上下拉刷新（底部间隙）";
            break;
        case 6:
            cell.textLabel.text = @"上下拉刷新（自定义颜色）";
            break;
        case 7:
            cell.textLabel.text = @"上下拉刷新（自定义文本）";
            break;
        case 8:
            cell.textLabel.text = @"上下拉刷新（隐藏时间）";
            break;
        case 9:
            cell.textLabel.text = @"上下拉刷新（隐藏状态和时间）";
            break;
        case 10:
            cell.textLabel.text = @"上下拉刷新（自定义动画）";
            break;
        default:
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    RefreshTableViewController *refreshVC = [[RefreshTableViewController alloc] init];
    refreshVC.selectedRow = indexPath.row;
    [self.navigationController pushViewController:refreshVC animated:YES];
}

@end
