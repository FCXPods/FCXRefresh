//
//  FCXDotPathAnimation.h
//  FCXRefreshDemo
//
//  Created by fcx on 2020/3/17.
//  Copyright © 2020 冯 传祥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCXDotPathAnimation : UIView

@property (nonatomic, assign) CGFloat progress;

- (void)startAnimating;
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
