//
//  ClockEmitterView.m
//  emitterTest
//
//  Created by zhourx5211 on 14-8-22.
//  Copyright (c) 2014年 zhourx5211. All rights reserved.
//

#import "ClockEmitterView.h"
#import "GlowPolygonView.h"
#import "UIView+UIImage.h"

@implementation ClockEmitterView
{
    GlowPolygonView *glowView;
    CAEmitterCell* emitterCell;
    CAEmitterLayer* emitter;
    CGFloat roundRadius;
    CGFloat rotateAngle;
    CGPoint roundCenter;
    
    NSTimer *timer;
    NSTimeInterval startTime;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self construct];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self construct];
    }
    
    return self;
}

- (void)construct
{
    self.backgroundColor = [UIColor clearColor];
    self.roundTime = 60.f;
    self.pointWidth = 30.f;
    self.edgeCount = 0;
    self.startAngle = -M_PI_2;
    self.clockwise = YES;
    self.color = [UIColor whiteColor];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
    [self setNeedsDisplay];
}

- (void)setStartAngle:(CGFloat)startAngle
{
    _startAngle = startAngle;
    [self adjustTransform];
}

- (void)setClockwise:(BOOL)clockwise
{
    _clockwise = clockwise;
    [self adjustTransform];
}

- (void)adjustTransform
{
    CGFloat scale = _clockwise ? 1 : -1;
    CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(_startAngle);
    self.transform = CGAffineTransformScale(rotateTransform, 1, scale);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    roundCenter = CGPointMake(width / 2 ,
                              height / 2);
    roundRadius = (width > height ? height : width) / 2;
    roundRadius -= self.pointWidth / 2;
    if (!glowView) {
        glowView = [[GlowPolygonView alloc] init];
        [self addSubview:glowView];
    }
    glowView.frame = CGRectMake(0,
                                0,
                                self.pointWidth,
                                self.pointWidth);
    glowView.color = self.color;
    glowView.edgeCount = self.edgeCount;
    glowView.clipsToBounds = NO;
    [self addEmitter];
    [self addRoundMovePath];
    [self addGlowRotateAnimation];
}

- (void)addRoundMovePath
{
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGRect circleContainer = CGRectMake(roundCenter.x - roundRadius,
                                        roundCenter.y - roundRadius,
                                        roundRadius * 2,
                                        roundRadius * 2);
    CGPathAddEllipseInRect(curvedPath, NULL, circleContainer);
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount = INFINITY;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.duration = self.roundTime;
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    [glowView.layer addAnimation:pathAnimation forKey:@"circleAnimation"];
    
    startTime = CFAbsoluteTimeGetCurrent();
    timer = [NSTimer scheduledTimerWithTimeInterval:1 / 60
                                             target:self
                                           selector:@selector(updateEmitter:)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)addGlowRotateAnimation
{
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotateAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    rotateAnimation.duration = self.roundTime;
    rotateAnimation.repeatCount = HUGE_VALF;
    [glowView.layer addAnimation:rotateAnimation forKey:@"rotation"];
}

- (void)updateEmitter:(NSTimer *)timer
{
    NSTimeInterval timerInterval = startTime - CFAbsoluteTimeGetCurrent();
    rotateAngle = -M_PI * 2 * timerInterval / self.roundTime;
    CGAffineTransform rotate = CGAffineTransformMakeRotation(rotateAngle);
    glowView.transform = rotate;
    CGFloat x = cos(rotateAngle) * roundRadius + roundCenter.x;
    CGFloat y = sin(rotateAngle) * roundRadius + roundCenter.y;
    CGFloat mod = rotateAngle - (rotateAngle / M_PI * 2) * M_PI * 2;
    if (mod > M_PI) {
        x = -x;
        y = -y;
    }
    CGPoint point = CGPointMake(x, y);
    emitter.emitterPosition = point;
    emitterCell.emissionLongitude = rotateAngle;
}

- (void)addEmitter
{
    emitterCell = [CAEmitterCell emitterCell];
    emitterCell.birthRate = 3.f * 60.f / self.roundTime;
    emitterCell.lifetime = 2.f / 60.f * self.roundTime;
    
    emitterCell.contents = (id)[glowView imageWithUIView:glowView].CGImage;
    emitterCell.name = @"copy";
    emitterCell.velocity = glowView.bounds.size.width / 2;
    emitterCell.velocityRange = emitterCell.velocity / 3;
    emitterCell.emissionRange = M_PI_2 / 6;
    emitterCell.scale = 0.4;
    emitterCell.scaleSpeed = -(emitterCell.scale / emitterCell.lifetime);
    emitterCell.spinRange = M_PI_2 * 2;
    
    emitter = [CAEmitterLayer layer];
    emitter.frame = self.bounds;
    emitter.emitterPosition = CGPointMake(roundCenter.x + roundRadius,
                                          roundCenter.y);
    emitter.emitterSize = CGSizeMake(glowView.bounds.size.width / 4, glowView.bounds.size.height / 4);
    emitter.renderMode = kCAEmitterLayerAdditive;
    emitter.emitterShape = kCAEmitterLayerLine;
    emitter.emitterMode = kCAEmitterLayerSurface;
    emitter.emitterCells = [NSArray arrayWithObject:emitterCell];
    [self.layer addSublayer:emitter];
}

@end
