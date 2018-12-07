//
//  FCXRefreshDotAnimationHeaderView.m
//  FCXRefreshDemo
//
//  Created by fcx on 2018/12/7.
//  Copyright © 2018 冯 传祥. All rights reserved.
//

#import "FCXRefreshDotAnimationHeaderView.h"

@interface FCXDotAnimationView : UIView
{
    CAShapeLayer *_shapeLayer;
    CAAnimationGroup *_animationGroup;
    CAReplicatorLayer *_replicatorLayer;
    CGFloat _maxSpace;
}

@end

@implementation FCXDotAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)startAnimating {
    [_shapeLayer addAnimation:[self fcxAnimationGroup] forKey:@"FCXDotAnimationGroup"];
}

- (void)stopAnimating {
    [_shapeLayer removeAnimationForKey:@"FCXDotAnimationGroup"];
}

- (void)setPercent:(CGFloat)percent {
    CGFloat diameter = 6;
    CGFloat space = 6 + (_maxSpace - 6) * (1 - percent);
    CGRect frame = _replicatorLayer.frame;
    frame.origin.x = (_maxSpace - space);
    _replicatorLayer.frame = frame;
    _replicatorLayer.instanceTransform = CATransform3DMakeTranslation(diameter + space, 0, 0);
}

- (void)setup {
    _maxSpace = 35;
    CGFloat diameter = 6;
    CGFloat left = (self.frame.size.width - diameter * 3 - _maxSpace * 2)/2.0;
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.frame = CGRectMake(left, 35, diameter, diameter);
    _shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, diameter, diameter)].CGPath;
    _shapeLayer.fillColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:199/255.0 alpha:1.0].CGColor;
    
    _replicatorLayer = [CAReplicatorLayer layer];
    _replicatorLayer.backgroundColor = [UIColor whiteColor].CGColor;
    _replicatorLayer.frame = self.bounds;
    _replicatorLayer.instanceDelay = 1/2.0;
    _replicatorLayer.instanceCount = 3;
    _replicatorLayer.instanceTransform = CATransform3DMakeTranslation(diameter + _maxSpace, 0, 0);
    [_replicatorLayer addSublayer:_shapeLayer];
    [self.layer addSublayer:_replicatorLayer];
}

- (CAAnimationGroup *)fcxAnimationGroup {
    if (_animationGroup) {
        return _animationGroup;
    }
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scale.values = @[[NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 1.0)],
                     [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.4, 1.4, 1.4)],
                     [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 1.0)],
                     [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 1.0)]
                     ];
    scale.keyTimes = @[@0, @0.25, @0.5, @1];
    
    //    scale.autoreverses = NO;
    scale.removedOnCompletion = NO;
    scale.repeatCount = HUGE;
    scale.duration = 3/2.0;
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@0.7,
                                @1,
                                @0.7,
                                @0.7
                                ];
    opacityAnimation.keyTimes = scale.keyTimes;
    
    //    scale.autoreverses = NO;
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.repeatCount = HUGE;
    opacityAnimation.duration = 3/2.0;
    
    _animationGroup = [CAAnimationGroup animation];
    _animationGroup.animations = @[scale, opacityAnimation];
    _animationGroup.duration = scale.duration;
    _animationGroup.repeatCount = HUGE;
    _animationGroup.autoreverses = NO;
    _animationGroup.removedOnCompletion = NO;
    return _animationGroup;
}

@end




@implementation FCXRefreshDotAnimationHeaderView
{
    FCXDotAnimationView *_animationView;
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
    
    //动画
    _animationView = [[FCXDotAnimationView alloc] initWithFrame:CGRectMake(0 + self.arrowOffsetX, (FCXHandingOffsetHeight - 40)/2.0, self.frame.size.width, 40)];
    [self addSubview:_animationView];
    
    __weak FCXDotAnimationView *weakAnimationView = _animationView;
    self.pullingPercentHandler = ^(CGFloat pullingPercent) {
        [weakAnimationView setPercent:pullingPercent];
    };
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _animationView.frame = CGRectMake(0 + self.arrowOffsetX, self.frame.size.height - FCXHandingOffsetHeight + (FCXHandingOffsetHeight - 40)/2.0, self.frame.size.width, 40);
}

- (void)fcxChangeToStatusNormal {
    [_animationView stopAnimating];
}

- (void)fcxChangeToStatusLoading {
    [_animationView startAnimating];
}

@end
