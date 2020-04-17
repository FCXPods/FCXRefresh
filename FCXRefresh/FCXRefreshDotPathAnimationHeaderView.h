//
//  FCXRefreshDotPathAnimationHeaderView.h
//  FCXRefreshDemo
//
//  Created by fcx on 2020/3/17.
//  Copyright © 2020 冯 传祥. All rights reserved.
//

#import "FCXRefreshHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCXRefreshDotPathAnimationHeaderView : FCXRefreshHeaderView

@property (nonatomic, copy) FCXPullingPercentHandler progressHandler;//!<刷新的相应事件

@end

NS_ASSUME_NONNULL_END
