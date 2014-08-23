//
//  ClockEmitterView.h
//  emitterTest
//
//  Created by zhourx5211 on 14-8-22.
//  Copyright (c) 2014年 zhourx5211. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClockEmitterView : UIView

// 转一圈的时间，默认60s
@property (assign, nonatomic) NSTimeInterval roundTime;

// 起点的角度，默认-90°（正上方）
@property (assign, nonatomic) CGFloat startAngle;

// 旋转图形的宽度
@property (assign, nonatomic) CGFloat pointWidth;

// 旋转图形的边个数（3~8，其他数字代表圆形，默认圆形）
@property (assign, nonatomic) NSUInteger edgeCount;

// 旋转图形颜色
@property (strong, nonatomic) UIColor *color;

// 顺时针旋转
@property (assign, nonatomic) BOOL clockwise;

@end
