//
//  UIScrollView+FCXRefresh.h
//  RefreshDemo
//
//  Created by fcx on 15/8/25.
//  Copyright (c) 2015年 fcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCXRefreshBaseView.h"


@interface UIScrollView (FCXRefresh)

- (__kindof FCXRefreshBaseView *)addHeaderWithRefreshHandler:(FCXRefreshedHandler)refreshHandler;
- (__kindof FCXRefreshBaseView *)addFooterWithRefreshHandler:(FCXRefreshedHandler)refreshHandler;

@end
