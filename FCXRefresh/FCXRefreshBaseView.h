//
//  FCXRefreshBaseView.h
//  RefreshPrj
//
//  Created by fcx on 15/8/21.
//  Copyright (c) 2015年 fcx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FCXRefreshState) {
    FCXRefreshStateNormal = 1,
    FCXRefreshStatePulling,
    FCXRefreshStateWillLoading,
    FCXRefreshStateLoading,
    FCXRefreshStateNoMoreData //上拉加载显示没有更多数据
};

typedef NS_ENUM(NSInteger, FCXRefreshViewType) {
    FCXRefreshViewTypeHeader = -1,
    FCXRefreshViewTypeFooter = 1
};

//刷新偏移量的高度
static const CGFloat FCXHandingOffsetHeight = 55;
//文本颜色
#define FCXREFRESHTEXTCOLOR [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]

@class FCXRefreshBaseView;
typedef void(^FCXRefreshedHandler)(FCXRefreshBaseView *refreshView);
typedef void(^FCXPullingPercentHandler)(CGFloat pullingPercent);


@interface FCXRefreshBaseView : UIView
{
    UILabel *_timeLabel;
    UILabel *_statusLabel;
    UIImageView *_arrowImageView;
    UIActivityIndicatorView *_activityView;
    __weak UIScrollView *_scrollView;//!<添加刷新的scrollView
    UIEdgeInsets _scrollViewOriginalEdgeInsets;
    FCXRefreshState _refreshState;//!<当前刷新状态
}

@property (nonatomic, strong, readonly) UILabel *statusLabel;
@property (nonatomic, strong, readonly) UILabel *timeLabel;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityView;
@property (nonatomic, assign) CGFloat arrowOffsetX;//!<调整箭头偏移量

@property (nonatomic, copy) FCXRefreshedHandler refreshHandler;//!<刷新的相应事件
@property (nonatomic, assign) FCXRefreshState refreshState;//!<当前刷新状态
@property (nonatomic, assign) CGFloat pullingPercent;
@property (nonatomic, copy) FCXPullingPercentHandler pullingPercentHandler;//!<刷新的相应事件

@property (nonatomic, copy) NSString *normalStateText;//!<正常状态文本
@property (nonatomic, copy) NSString *pullingStateText;//!<下拉状态提示文本
@property (nonatomic, copy) NSString *loadingStateText;//!<加载中的提示文本
@property (nonatomic, copy) NSString *noMoreDataStateText;//!<没有更多数据提示文本
@property (nonatomic, unsafe_unretained) BOOL autoLoadMore;//!<是否自动加载更多，默认上拉超过scrollView的内容高度时，直接加载更多

@property (nonatomic, assign, readonly) UIEdgeInsets scrollViewEdgeInsets;
@property (nonatomic, assign) CGFloat loadMoreBottomExtraSpace;//!<加载更多底部显示时额外的高度
@property (nonatomic, assign) BOOL loadMoreIgnoreContentSize;//!<加载更多时忽略ContentSize的高度是否大于自身frame高度（判断高度性能更好，默认值NO，也就是当ContentSize高度小于自身frame高度时不会加载更多），这里是为了处理数据内容小于自身高度还需自动加载更多


//设置各种状态的文本，需子类重写
- (void)setupStateText;

/**
 *  添加刷新的界面
 *
 *  注：如果想自定义刷新加载界面，可在子类中重写该方法进行布局子界面
 */
- (void)addRefreshContentView;
//自动刷新
- (void)autoRefresh;
//结束刷新
- (void)endRefresh;
// 当scrollView的contentOffset发生改变的时候调用
- (void)scrollViewContentOffsetDidChange;
// 当scrollView的contentSize发生改变的时候调用
- (void)scrollViewContentSizeDidChange;
//显示没有更多数据
- (void)showNoMoreData;
//重置没有更多的数据（消除没有更多数据的状态）
- (void)resetNoMoreData;
//隐藏时间
- (void)hideTime;
//隐藏状态和时间
- (void)hideStatusAndTime;

//状态改变时，可以对动画等作出自定义处理
- (void)fcxChangeToStatusNormal;
- (void)fcxChangeToStatusPulling;
- (void)fcxChangeToStatusWillLoading;
- (void)fcxChangeToStatusLoading;
- (void)fcxChangeToStatusNoMoreData;

@end
