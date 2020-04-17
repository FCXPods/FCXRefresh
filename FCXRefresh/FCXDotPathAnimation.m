//
//  FCXDotPathAnimation.m
//  FCXRefreshDemo
//
//  Created by fcx on 2020/3/17.
//  Copyright © 2020 冯 传祥. All rights reserved.
//

#import "FCXDotPathAnimation.h"

CGFloat const FCXDotPathAnimationContentHeight = 40.0;
CGFloat const FCXDotPathAnimationRadius = 5.0;
CGFloat const FCXDoLinttAnimationTranslateDistance = 5.0;

@implementation FCXDotPathAnimation
{
    CALayer *_bgLayer;
    CAShapeLayer *_topLayer;
    CAShapeLayer *_bottomLayer;
    CAShapeLayer *_leftLayer;
    CAShapeLayer *_rightLayer;
    CAShapeLayer *_lineLayer;
    CGFloat _minScaleProgress;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addContentLayer];
    }
    return self;
}

- (void)addContentLayer {
    _minScaleProgress = 1/8.0;
    _bgLayer = [CALayer layer];
    _bgLayer.frame = CGRectMake((self.frame.size.width - FCXDotPathAnimationContentHeight)/2.0, (self.frame.size.height - FCXDotPathAnimationContentHeight)/2.0, FCXDotPathAnimationContentHeight, FCXDotPathAnimationContentHeight);
    [self.layer addSublayer:_bgLayer];
    
    UIColor *topPointColor = [UIColor colorWithRed:90/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    UIColor *leftPointColor = [UIColor colorWithRed:250/255.0 green:85/255.0 blue:78/255.0 alpha:1.0];
    UIColor *bottomPointColor = [UIColor colorWithRed:92/255.0 green:201/255.0 blue:105/255.0 alpha:1.0];
    UIColor *rightPointColor = [UIColor colorWithRed:253/255.0 green:175/255.0 blue:75/255.0 alpha:1.0];
    CGFloat dotSize = FCXDotPathAnimationRadius * 2;
    
    _topLayer = [self addDotLayerWithFrame:CGRectMake(_bgLayer.frame.size.width/2.0 - FCXDotPathAnimationRadius, 0, dotSize, dotSize) color:topPointColor.CGColor];
    _topLayer.hidden = NO;
    _leftLayer = [self addDotLayerWithFrame:CGRectMake(0, _bgLayer.frame.size.height/2.0 - FCXDotPathAnimationRadius, dotSize, dotSize) color:leftPointColor.CGColor];
    _bottomLayer = [self addDotLayerWithFrame:CGRectMake(_bgLayer.frame.size.width/2.0 - FCXDotPathAnimationRadius, _bgLayer.frame.size.height - dotSize, dotSize, dotSize) color:bottomPointColor.CGColor];
    _rightLayer = [self addDotLayerWithFrame:CGRectMake(_bgLayer.frame.size.width - dotSize,  _bgLayer.frame.size.height/2.0 - FCXDotPathAnimationRadius, dotSize, dotSize) color:rightPointColor.CGColor];
    
    _lineLayer = [CAShapeLayer layer];
    _lineLayer.frame = self.bounds;
    _lineLayer.lineWidth = FCXDotPathAnimationRadius * 2;
    _lineLayer.lineCap = kCALineCapRound;
    _lineLayer.lineJoin = kCALineJoinRound;
    _lineLayer.fillColor = [UIColor clearColor].CGColor;
    _lineLayer.strokeColor = topPointColor.CGColor;
    UIBezierPath * path = [UIBezierPath bezierPath];
    CGPoint topPoint = CGPointMake(_bgLayer.frame.size.width/2.0, FCXDotPathAnimationRadius);
    [path moveToPoint:topPoint];
    [path addLineToPoint:CGPointMake(FCXDotPathAnimationRadius, _bgLayer.frame.size.height/2.0)];
    [path addLineToPoint:CGPointMake(_bgLayer.frame.size.width/2.0, _bgLayer.frame.size.height - FCXDotPathAnimationRadius)];
    [path addLineToPoint:CGPointMake(_bgLayer.frame.size.width - FCXDotPathAnimationRadius, _bgLayer.frame.size.height/2.0)];
    [path addLineToPoint:topPoint];
    _lineLayer.path = path.CGPath;
    _lineLayer.strokeStart = 0.f;
    _lineLayer.strokeEnd = 0.25f;
    [_bgLayer insertSublayer:_lineLayer above:_topLayer];
}

- (CAShapeLayer *)addDotLayerWithFrame:(CGRect)frame color:(CGColorRef)color {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = frame;
    layer.fillColor = color;
    layer.path = [UIBezierPath bezierPathWithOvalInRect:layer.bounds].CGPath;
    layer.hidden = YES;
    [_bgLayer addSublayer:layer];
    return layer;
}

- (void)startAnimating {
    [self addTranslationAnimationToLayer:_topLayer xValue:0 yValue:FCXDoLinttAnimationTranslateDistance];
    [self addTranslationAnimationToLayer:_leftLayer xValue:FCXDoLinttAnimationTranslateDistance yValue:0];
    [self addTranslationAnimationToLayer:_bottomLayer xValue:0 yValue:-FCXDoLinttAnimationTranslateDistance];
    [self addTranslationAnimationToLayer:_rightLayer xValue:-FCXDoLinttAnimationTranslateDistance yValue:0];
    [self addRotationAnimationToLayer:_bgLayer];
}

- (void)stopAnimating {
    [_topLayer removeAllAnimations];
    [_leftLayer removeAllAnimations];
    [_bottomLayer removeAllAnimations];
    [_rightLayer removeAllAnimations];
    [_bgLayer removeAllAnimations];
}

- (void)addTranslationAnimationToLayer:(CALayer *)layer xValue:(CGFloat)x yValue:(CGFloat)y {
    CAKeyframeAnimation * translationKeyframeAni = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    translationKeyframeAni.duration = 1.0;
    translationKeyframeAni.repeatCount = HUGE;
    translationKeyframeAni.removedOnCompletion = NO;
    translationKeyframeAni.fillMode = kCAFillModeForwards;
    translationKeyframeAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    NSValue * fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0.f)];
    NSValue * toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(x, y, 0.f)];
    translationKeyframeAni.values = @[fromValue, toValue, fromValue, toValue, fromValue];
    [layer addAnimation:translationKeyframeAni forKey:@"FCXTranslationAnimation"];
}

- (void)addRotationAnimationToLayer:(CALayer *)layer {
    CABasicAnimation * rotationAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAni.fromValue = @(0);
    rotationAni.toValue = @(M_PI * 2);
    rotationAni.duration = 1.0;
    rotationAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAni.repeatCount = HUGE;
    rotationAni.fillMode = kCAFillModeForwards;
    rotationAni.removedOnCompletion = NO;
    [layer addAnimation:rotationAni forKey:@"FCXDotAnimation"];
}

- (void)setProgress:(CGFloat)progress {
    if (_progress != progress) {
        _progress = progress;
        CGFloat start = 0, end = 0;
        NSInteger step = progress/0.25;
        
        start = MAX(0.25 * step, progress - _minScaleProgress);
        end = MIN(0.25 * (step + 1), progress * 2 - 0.25 * step);
        [self adjustDotHiddenWithIndex:end/0.25];
        switch (step) {
            case 0:
                _lineLayer.strokeColor = _topLayer.fillColor;
                break;
            case 1:
                _lineLayer.strokeColor = _leftLayer.fillColor;
                break;
            case 2:
                _lineLayer.strokeColor = _bottomLayer.fillColor;
                break;
            case 3:
                _lineLayer.strokeColor = _rightLayer.fillColor;
                break;
            default:
                _lineLayer.strokeColor = _topLayer.fillColor;
                break;
        }
        _lineLayer.strokeStart = start;
        _lineLayer.strokeEnd = end;
    }
}

- (void)adjustDotHiddenWithIndex:(NSInteger)index {
    _leftLayer.hidden = index < 2;
    _bottomLayer.hidden = index < 3;
    _rightLayer.hidden = index < 4;
}

- (void)dealloc {
    [self stopAnimating];
}

@end
