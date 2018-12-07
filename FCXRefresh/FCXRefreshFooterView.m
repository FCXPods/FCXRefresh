//
//  FCXRefreshFooterView.m
//  RefreshPrj
//
//  Created by fcx on 15/8/21.
//  Copyright (c) 2015年 fcx. All rights reserved.
//

#import "FCXRefreshFooterView.h"

@implementation FCXRefreshFooterView
@synthesize autoLoadMore = _autoLoadMore;

- (void)setupStateText {
    self.normalStateText = @"上拉加载更多";
    self.pullingStateText = @"松开可加载更多";
    self.loadingStateText = @"正在加载更多...";
    self.noMoreDataStateText = @"没有更多数据";
}

- (void)addRefreshContentView {
    CGFloat width = self.frame.size.width;
    
    //刷新状态
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.frame = CGRectMake(0, 0, width, FCXHandingOffsetHeight);
    _statusLabel.font = [UIFont systemFontOfSize:12];
    _statusLabel.textColor = FCXREFRESHTEXTCOLOR;
//    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_statusLabel];
    
    //箭头图片
    _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fcx_arrow"]];
    _arrowImageView.frame = CGRectMake(width/2.0 - 90, 11, 15, 40);
    [self addSubview:_arrowImageView];
    
    //转圈动画
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.frame = CGRectMake(width/2.0 - 90, (FCXHandingOffsetHeight - 40)/2.0, 15, 40);
    [self addSubview:_activityView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_statusLabel.hidden) {
        _statusLabel.frame = CGRectMake(0, 0, self.frame.size.width, FCXHandingOffsetHeight);
    }
    if (!_autoLoadMore) {
        _arrowImageView.frame = CGRectMake(self.frame.size.width/2.0 - (_statusLabel.hidden ? 7.5 : 90) + self.arrowOffsetX, (FCXHandingOffsetHeight - 40)/2.0, 15, 40);
        _activityView.frame = _arrowImageView.frame;
    }
}

- (void)setAutoLoadMore:(BOOL)autoLoadMore {
    _autoLoadMore = autoLoadMore;
    if (_autoLoadMore) {//自动加载更多不显示箭头
        [_arrowImageView removeFromSuperview];
        _arrowImageView = nil;
        self.normalStateText = @"正在加载更多...";
        self.pullingStateText = @"正在加载更多...";
        self.loadingStateText = @"正在加载更多...";
    }
}

- (void)scrollViewContentSizeDidChange {
    CGRect frame = self.frame;
    frame.origin.y =  MAX(_scrollView.frame.size.height - self.scrollViewEdgeInsets.top - self.scrollViewEdgeInsets.bottom, _scrollView.contentSize.height) + self.loadMoreBottomExtraSpace;
    self.frame = frame;
}

- (void)scrollViewContentOffsetDidChange {
    if (self.refreshState == FCXRefreshStateNoMoreData) {//没有更多数据
        return;
    }
    
    CGFloat edgeTop = self.scrollViewEdgeInsets.top;
    CGFloat edgeBottom = self.scrollViewEdgeInsets.bottom + self.loadMoreBottomExtraSpace;

    //scrollview实际显示内容高度
    CGFloat realHeight = _scrollView.frame.size.height - edgeTop - edgeBottom;
    /// 计算超出scrollView的高度
    CGFloat beyondScrollViewHeight = _scrollView.contentSize.height - realHeight;
    if (beyondScrollViewHeight <= 0 && !self.loadMoreIgnoreContentSize) {
        //scrollView的实际内容高度没有超出本身高度不处理
        return;
    }
    
    //刚刚出现底部控件时出现的offsetY
    CGFloat offSetY = beyondScrollViewHeight - edgeTop;
    // 当前scrollView的contentOffsetY超出offsetY的高度
    CGFloat beyondOffsetHeight = _scrollView.contentOffset.y - offSetY;
    if (beyondOffsetHeight < 0) {
        return;
    }

    if (self.autoLoadMore) {//如果是自动加载更多
        //大于偏移量，转为加载更多loading
        self.refreshState = FCXRefreshStateLoading;
        return;
    }
    
    if (_scrollView.isDragging) {
        if (beyondOffsetHeight > FCXHandingOffsetHeight) {//大于偏移量，转为pulling
            self.refreshState = FCXRefreshStatePulling;
        }else {//小于偏移量，转为正常normal
            self.refreshState = FCXRefreshStateNormal;
        }
    } else {
        if (self.refreshState == FCXRefreshStatePulling) {//如果是pulling状态，改为加载更多loading
            self.refreshState = FCXRefreshStateLoading;
        }else {
            self.refreshState = FCXRefreshStateNormal;
        }
    }
    
    if (self.pullingPercentHandler) {
        if (beyondOffsetHeight > FCXHandingOffsetHeight) {
            if (self.pullingPercent == 1) {
                return;
            }
            beyondOffsetHeight = FCXHandingOffsetHeight;
        }
        self.pullingPercent = beyondOffsetHeight/FCXHandingOffsetHeight;
    }
}

- (void)setRefreshState:(FCXRefreshState)refreshState {
    FCXRefreshState lastRefreshState = _refreshState;
    if (_refreshState != refreshState) {
        _refreshState = refreshState;
        switch (refreshState) {
            case FCXRefreshStateNormal:
            {                
                _statusLabel.text = self.normalStateText;
                if (lastRefreshState == FCXRefreshStateLoading) {//之前是刷新过
                    _arrowImageView.hidden = YES;
                } else {
                    _arrowImageView.hidden = NO;
                }
                [self fcxChangeToStatusNormal];
                
                [UIView animateWithDuration:0.2 animations:^{
                    _arrowImageView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
                    _scrollView.contentInset = _scrollViewOriginalEdgeInsets;
                }];                
            }
                break;
            case FCXRefreshStatePulling:
            {
                _statusLabel.text = self.pullingStateText;
                [UIView animateWithDuration:0.2 animations:^{
                    _arrowImageView.transform = CGAffineTransformIdentity;
                }];
            }
                break;
            case FCXRefreshStateLoading:
            {
                _statusLabel.text = self.loadingStateText;
                _arrowImageView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
                [self fcxChangeToStatusLoading];
                [UIView animateWithDuration:0.2 animations:^{
                    UIEdgeInsets inset = _scrollView.contentInset;
                    inset.bottom += (FCXHandingOffsetHeight + self.loadMoreBottomExtraSpace);
                    _scrollView.contentInset = inset;
                    inset.bottom = self.frame.origin.y - _scrollView.contentSize.height + FCXHandingOffsetHeight;
                    _scrollView.contentInset = inset;
                }];
                
                if (self.refreshHandler) {
                    self.refreshHandler(self);
                }
            }
                break;
            case FCXRefreshStateNoMoreData:
            {
                _statusLabel.text = self.noMoreDataStateText;
                [self fcxChangeToStatusNoMoreData];
            }
                break;
            default:
                break;
        }
    }
}

- (void)showNoMoreData {
    [self endRefresh];
    self.refreshState = FCXRefreshStateNoMoreData;
    _arrowImageView.hidden = YES;
}

- (void)resetNoMoreData {
    self.refreshState = FCXRefreshStateNormal;
}

@end
