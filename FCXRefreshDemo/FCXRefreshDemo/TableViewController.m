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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseId forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"下拉刷新+上拉刷新";
            break;
        case 1:
            cell.textLabel.text = @"自动下拉刷新+上拉刷新";
            break;
        case 2:
            cell.textLabel.text = @"下拉刷新+上拉自动刷新";
            break;
        case 3:
            cell.textLabel.text = @"下拉刷新+上拉刷新(控制加载个数)";
            break;
        case 4:
            cell.textLabel.text = @"下拉刷新+上拉刷新(显示百分比)";
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
