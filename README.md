# FCXRefresh

[![CocoaPods compatible](https://img.shields.io/cocoapods/v/FCXRefresh.svg)](http://cocoadocs.org/docsets/FCXRefresh/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](http://img.shields.io/cocoapods/p/FCXRefresh.svg?style=flat)](https://github.com/FCXPods/FCXRefresh)

[FCXRefresh](https://github.com/FCXPods/FCXRefresh)是一个使用OC编写、用于上下拉刷新的控件。

## 特性

- [x] 普通上下拉刷新
- [x] 自动下拉刷新
- [x] 上拉无更多数据控制
- [x] 上下拉百分比显示
- [x] 自定义上下拉动画
- [x] 上拉底部间距控制


## 环境

- Xcode 11+
- iOS 8.0+

## 如何导入

### CocoaPods

```ruby
pod 'FCXRefresh'
```

### Carthage

```ogdl
github "FCXPods/FCXRefresh"
```

### 手动导入

把FCXRefresh文件夹导入即可

## 如何使用

### 包含头文件

```objc
#import "UIScrollView+FCXRefresh.h"
```

### 添加上下拉刷新

```objc
//下拉刷新
_refreshHeaderView = [self.tableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
    [weakSelf refreshAction];
}];

//上拉加载更多
_refreshFooterView = [self.tableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
    [weakSelf loadMoreAction];
}];
```

### 刷新自定义设置

```objc
//自动下拉刷新
[_refreshHeaderView autoRefresh];

//自动上拉加载更多
_refreshFooterView.autoLoadMore = YES;

//上拉底部间距设置
_refreshFooterView.loadMoreBottomExtraSpace = 30;
```

### 上下拉百分比显示

```objc
_refreshHeaderView.pullingPercentHandler = ^(CGFloat pullingPercent) {
    headerPercentLabel.text = [NSString stringWithFormat:@"%.2f%%", pullingPercent * 100];
};

_refreshFooterView.pullingPercentHandler = ^(CGFloat pullingPercent) {
    footerPercentLabel.text = [NSString stringWithFormat:@"%.2f%%", pullingPercent * 100];
};
```

## 显示效果：

![FCXRefresh.gif](https://raw.githubusercontent.com/FCXPods/FCXRefresh/master/FCXRefresh.gif)

## License

FCXRefresh is released under the MIT license. See [LICENSE](https://github.com/FCXPods/FCXRefresh/blob/master/LICENSE) for details.
