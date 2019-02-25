//
//  FCXRefreshHeaderView.m
//  RefreshPrj
//
//  Created by fcx on 15/8/21.
//  Copyright (c) 2015年 fcx. All rights reserved.
//

#import "FCXRefreshHeaderView.h"

@implementation FCXRefreshHeaderView

- (void)setupStateText {
    self.normalStateText = @"下拉刷新";
    self.pullingStateText = @"松开可刷新";
    self.loadingStateText = @"正在刷新...";
}

- (void)addRefreshContentView {
    CGFloat width = self.frame.size.width;

    //刷新状态
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.frame = CGRectMake(0, 15, width, 20);
    _statusLabel.font = [UIFont systemFontOfSize:12];
    _statusLabel.textColor = FCXREFRESHTEXTCOLOR;
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_statusLabel];

    //更新时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.frame = CGRectMake(0, 35, width, 20);
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = _statusLabel.textColor;
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_timeLabel];
    
    //箭头图片
    _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fcx_arrow"]];
    _arrowImageView.frame = CGRectMake(width/2.0 - 100, (FCXHandingOffsetHeight - 40)/2.0 + 5, 15, 40);
    [self addSubview:_arrowImageView];
    
    //转圈动画
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.frame = _arrowImageView.frame;
    [self addSubview:_activityView];
    [self updateTimeLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_timeLabel.hidden && _statusLabel.hidden) {//状态时间隐藏
        _arrowImageView.frame = CGRectMake(self.frame.size.width/2.0 - 7.5 + self.arrowOffsetX, self.frame.size.height - FCXHandingOffsetHeight + (FCXHandingOffsetHeight - 40)/2.0, 15, 40);
        _activityView.frame = _arrowImageView.frame;
    } else if (_timeLabel.hidden) {//时间隐藏
        _statusLabel.frame = CGRectMake(0, self.frame.size.height - FCXHandingOffsetHeight, self.frame.size.width, FCXHandingOffsetHeight);
        _arrowImageView.frame = CGRectMake(self.frame.size.width/2.0 - 100 + self.arrowOffsetX, self.frame.size.height - FCXHandingOffsetHeight + (FCXHandingOffsetHeight - 40)/2.0, 15, 40);
        _activityView.frame = _arrowImageView.frame;
    } else {
        _statusLabel.frame = CGRectMake(0, self.frame.size.height - 45, self.frame.size.width, 20);
        _timeLabel.frame = CGRectMake(0, self.frame.size.height - 25, self.frame.size.width, 20);
        _arrowImageView.frame = CGRectMake(self.frame.size.width/2.0 - 100 + self.arrowOffsetX, self.frame.size.height - FCXHandingOffsetHeight + (FCXHandingOffsetHeight - 40)/2.0, 15, 40);
        _activityView.frame = _arrowImageView.frame;
    }
}

- (void)scrollViewContentOffsetDidChange {
    CGFloat edgeTop = self.scrollViewEdgeInsets.top;
    if (_scrollView.contentOffset.y > -edgeTop) {
        //向上滚动到看不见头部控件，直接返回
        return;
    }

    if (_scrollView.isDragging) {//正在拖拽
        if (_scrollView.contentOffset.y + edgeTop < -FCXHandingOffsetHeight) {//大于偏移量，转为pulling
            self.refreshState = FCXRefreshStatePulling;
        } else {//小于偏移量，转为正常normal
            self.refreshState = FCXRefreshStateNormal;
        }
    } else {
        if (self.refreshState == FCXRefreshStatePulling) {//如果是pulling状态，改为刷新加载loading
            self.refreshState = FCXRefreshStateLoading;
        } else if (self.refreshState != FCXRefreshStateWillLoading)  {
            self.refreshState = FCXRefreshStateNormal;
        }
    }
    
    if (self.pullingPercentHandler) {
        CGFloat offsetHeight = -_scrollView.contentOffset.y - edgeTop;
        if (offsetHeight >= 0) {
            if (offsetHeight > FCXHandingOffsetHeight) {
                if (self.pullingPercent == 1) {
                    return;
                }
                offsetHeight = FCXHandingOffsetHeight;
            }
            self.pullingPercent = offsetHeight/FCXHandingOffsetHeight;
        }
    }
}

- (void)setRefreshState:(FCXRefreshState)refreshState {
    FCXRefreshState lastRefreshState = _refreshState;
    if (_refreshState != refreshState) {
        _refreshState = refreshState;
        switch (refreshState) {
            case FCXRefreshStateNormal:
            {
                [self fcxChangeToStatusNormal];
                _statusLabel.text = self.normalStateText;
                if (lastRefreshState == FCXRefreshStateLoading) {//之前是在刷新
                    [self updateTimeLabel];
                }
                [UIView animateWithDuration:0.2 animations:^{
                    _arrowImageView.transform = CGAffineTransformIdentity;
                    _scrollView.contentInset = _scrollViewOriginalEdgeInsets;
                }];
            }
                break;
            case FCXRefreshStatePulling:
            {
                [self fcxChangeToStatusPulling];
                _statusLabel.text = self.pullingStateText;
                [UIView animateWithDuration:0.2 animations:^{
                    _arrowImageView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
                }];
            }
                break;
            case FCXRefreshStateLoading:
            {
                [self fcxChangeToStatusLoading];
                _statusLabel.text = self.loadingStateText;
                _arrowImageView.transform = CGAffineTransformIdentity;
                [UIView animateWithDuration:0.2 animations:^{
                    UIEdgeInsets edgeInset = _scrollViewOriginalEdgeInsets;
                    edgeInset.top += FCXHandingOffsetHeight;
                    _scrollView.contentInset = edgeInset;
                }];
                if (self.refreshHandler) {
                    self.refreshHandler(self);
                }
            }
                break;
            case FCXRefreshStateNoMoreData:
            {
                [self fcxChangeToStatusNoMoreData];
            }
                break;
            default:
                break;
        }
    }
}

- (void)autoRefresh {
    if (self.refreshState == FCXRefreshStateLoading) {
        return;
    }

    // 已经显示
    if (self.window) {
        [self adjustContentOffsetShowLoading];
        return;
    }
    self.refreshState = FCXRefreshStateWillLoading;
    [self setNeedsDisplay];
}

- (void)adjustContentOffsetShowLoading {
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView.contentOffset = CGPointMake(0, -FCXHandingOffsetHeight - self.scrollViewEdgeInsets.top);
    } completion:^(BOOL finished) {
        self.refreshState = FCXRefreshStateLoading;
    }];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 预防view还没显示出来就调用了beginRefreshing
    if (self.refreshState == FCXRefreshStateWillLoading) {
        [self adjustContentOffsetShowLoading];
    }
}

- (void)updateTimeLabel {
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary] ;
    NSDateFormatter *dateFormatter = [threadDictionary objectForKey: @"FCXRefeshDateFormatterKey"] ;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init] ;
        [dateFormatter setDateFormat: @"最后更新：今天 HH:mm"] ;
        [threadDictionary setObject: dateFormatter forKey: @"FCXRefeshDateFormatterKey"] ;
    }
    _timeLabel.text = [dateFormatter stringFromDate:[NSDate date]];
}

@end
