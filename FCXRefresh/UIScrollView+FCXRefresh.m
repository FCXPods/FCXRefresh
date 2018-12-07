//
//  UIScrollView+FCXRefresh.m
//  RefreshDemo
//
//  Created by fcx on 15/8/25.
//  Copyright (c) 2015年 fcx. All rights reserved.
//

#import "UIScrollView+FCXRefresh.h"
#import "FCXRefreshHeaderView.h"
#import "FCXRefreshFooterView.h"

@implementation UIScrollView (FCXRefresh)

- (__kindof FCXRefreshBaseView *)addHeaderWithRefreshHandler:(FCXRefreshedHandler)refreshHandler {
    FCXRefreshHeaderView *header = [[FCXRefreshHeaderView alloc] initWithFrame:CGRectMake(0, -FCXHandingOffsetHeight, self.frame.size.width, FCXHandingOffsetHeight)];
    header.backgroundColor = [UIColor clearColor];//10.3系统上默认颜色是黑色
    header.refreshHandler = refreshHandler;
    [self addSubview:header];
    return header;
}

- (__kindof FCXRefreshBaseView *)addFooterWithRefreshHandler:(FCXRefreshedHandler)refreshHandler {
    FCXRefreshFooterView *footer = [[FCXRefreshFooterView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, [UIScreen mainScreen].bounds.size.width, FCXHandingOffsetHeight)];
    footer.backgroundColor = [UIColor clearColor];
    footer.refreshHandler = refreshHandler;
    [self addSubview:footer];
    return footer;
}

@end
