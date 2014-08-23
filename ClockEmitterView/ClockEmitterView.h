//
//  ClockEmitterView.h
//  emitterTest
//
//  Created by zhourx5211 on 14-8-22.
//  Copyright (c) 2014年 zhourx5211. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClockEmitterView : UIView

@property (assign, nonatomic) NSTimeInterval roundTime;
@property (assign, nonatomic) CGFloat startAngle;
@property (assign, nonatomic) CGFloat pointWidth;
@property (assign, nonatomic) NSUInteger edgeCount;
@property (assign, nonatomic) BOOL clockwise;
@property (strong, nonatomic) UIColor *color;

@end
