//
//  FCXRefreshDotPathAnimationHeaderView.m
//  FCXRefreshDemo
//
//  Created by fcx on 2020/3/17.
//  Copyright © 2020 冯 传祥. All rights reserved.
//

#import "FCXRefreshDotPathAnimationHeaderView.h"
#import "FCXDotPathAnimation.h"

@implementation FCXRefreshDotPathAnimationHeaderView
{
    FCXDotPathAnimation *_animationView;
}

- (void)addRefreshContentView {
    _animationView = [[FCXDotPathAnimation alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 55, self.frame.size.width, 55)];
    [self addSubview:_animationView];
    
    __weak FCXDotPathAnimation *weakAnimationView = _animationView;
    __weak typeof(self) weakSelf = self;
    self.pullingPercentHandler = ^(CGFloat pullingPercent) {
        weakAnimationView.progress = pullingPercent;
        if (weakSelf.progressHandler) {
            weakSelf.progressHandler(pullingPercent);
        }
    };
}

- (void)fcxChangeToStatusLoading {
    [super fcxChangeToStatusLoading];
    [_animationView startAnimating];
}

- (void)fcxChangeToStatusNormal {
    [super fcxChangeToStatusNormal];
    [_animationView stopAnimating];
}

@end
