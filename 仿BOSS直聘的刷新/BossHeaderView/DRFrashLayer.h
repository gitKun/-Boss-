//
//  DRFrashLayer.h
//  画图测试
//
//  Created by apple on 16/3/18.
//  Copyright © 2016年 kun. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

/** 请于许我做个悲伤的表情 */
@interface DRFrashLayer : CALayer

@property (nonatomic, assign) CGFloat complete;

/** @brief  动画属性 (外部无需调用) */
@property (nonatomic, assign) CGFloat animationScale;

/** 开始动画 开始刷新时调用 (可自己修改动画时长) */
- (void)beginAnimation;
/** 结束动画，舒心结束调用 */
- (void)stopAnimation;

@end
