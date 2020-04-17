//
//  FCXRefreshBaseView.m
//  RefreshPrj
//
//  Created by fcx on 15/8/21.
//  Copyright (c) 2015年 fcx. All rights reserved.
//

#import "FCXRefreshBaseView.h"


@implementation FCXRefreshBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addRefreshContentView];
        [self setupStateText];
        self.refreshState = FCXRefreshStateNormal;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self removeScrollViewObservers];
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        _scrollView = (UIScrollView *)newSuperview;
        _scrollViewOriginalEdgeInsets = _scrollView.contentInset;
        [self addScrollViewObservers];
    }
}

- (void)addRefreshContentView {}
- (void)setupStateText {}
- (void)autoRefresh {}
- (void)endRefresh {
    self.refreshState = FCXRefreshStateNormal;
    if (self.pullingPercentHandler) {
        self.pullingPercent = 0;
    }
}
- (void)showNoMoreData {}
- (void)resetNoMoreData {}
- (void)setPullingPercent:(CGFloat)pullingPercent {
    if (_pullingPercent != pullingPercent) {
        _pullingPercent = pullingPercent;
        if (_pullingPercentHandler) {
            _pullingPercentHandler(_pullingPercent);
        }
    }
}

#pragma mark - KVO

- (void)addScrollViewObservers {
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeScrollViewObservers {
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        [self.superview removeObserver:self forKeyPath:@"contentOffset" context:nil];
        [self.superview removeObserver:self forKeyPath:@"contentSize" context:nil];
        [self.superview removeObserver:self forKeyPath:@"contentInset" context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        //正在刷新
        if (_refreshState == FCXRefreshStateLoading) {
            return;
        }
        // contentInset可能会变
        _scrollViewOriginalEdgeInsets = _scrollView.contentInset;
        [self scrollViewContentOffsetDidChange];
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        [self scrollViewContentSizeDidChange];
    } else if ([keyPath isEqualToString:@"contentInset"]) {
        if (_refreshState == FCXRefreshStateLoading) {
            return;
        }
        _scrollViewOriginalEdgeInsets = _scrollView.contentInset;
    }
}

- (void)scrollViewContentOffsetDidChange {}
- (void)scrollViewContentSizeDidChange {}

- (void)hideTime {
    _timeLabel.hidden = YES;
    [self setNeedsLayout];
}

- (void)hideStatusAndTime {
    _timeLabel.hidden = YES;
    _statusLabel.hidden = YES;
    [self setNeedsLayout];
}

#pragma mark - 状态改变处理动画

- (void)fcxChangeToStatusNormal {}

- (void)fcxChangeToStatusLoading {}
- (void)fcxChangeToStatusPulling {}
- (void)fcxChangeToStateWillLoading {}
- (void)fcxChangeToStatusNoMoreData {}
- (void)fcxChangeToRefreshDate {}

#pragma mark - set、get

- (void)setRefreshState:(FCXRefreshState)refreshState {
    FCXRefreshState lastRefreshState = _refreshState;
    if (_refreshState != refreshState) {
        _refreshState = refreshState;
        switch (refreshState) {
            case FCXRefreshStateNormal:
            {
                [self fcxChangeToStatusNormal];
                if (lastRefreshState == FCXRefreshStateLoading) {//之前是在刷新
                    [self fcxChangeToRefreshDate];
                }
            }
                break;
            case FCXRefreshStatePulling:
            {
                [self fcxChangeToStatusPulling];
            }
                break;
            case FCXRefreshStateWillLoading:
            {
                [self fcxChangeToStateWillLoading];
            }
                break;
            case FCXRefreshStateLoading:
            {
                [self fcxChangeToStatusLoading];
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

- (UIEdgeInsets)scrollViewEdgeInsets {
    if (@available(iOS 11.0, *)) {
        return _scrollView.adjustedContentInset;
    }
    return _scrollView.contentInset;
}

- (void)setNormalStateText:(NSString *)normalStateText {
    if (_normalStateText != normalStateText) {
        _normalStateText = normalStateText;
        if (self.refreshState == FCXRefreshStateNormal) {
            _statusLabel.text = _normalStateText;
        }
    }
}

- (void)setPullingStateText:(NSString *)pullingStateText {
    if (_pullingStateText != pullingStateText) {
        _pullingStateText = pullingStateText;
        if (self.refreshState == FCXRefreshStatePulling) {
            _statusLabel.text = _pullingStateText;
        }
    }
}

- (void)setLoadingStateText:(NSString *)loadingStateText {
    if (_loadingStateText != loadingStateText) {
        _loadingStateText = loadingStateText;
        if (self.refreshState == FCXRefreshStateLoading) {
            _statusLabel.text = _loadingStateText;
        }
    }
}

- (void)setNoMoreDataStateText:(NSString *)noMoreDataStateText {
    if (_noMoreDataStateText != noMoreDataStateText) {
        _noMoreDataStateText = noMoreDataStateText;
        if (self.refreshState == FCXRefreshStateNoMoreData) {
            _statusLabel.text = _noMoreDataStateText;
        }
    }
}

@end
