//
//  GlowPolygonView.m
//  emitterTest
//
//  Created by zhourx5211 on 14-8-23.
//  Copyright (c) 2014年 zhourx5211. All rights reserved.
//

#import "GlowPolygonView.h"

@implementation GlowPolygonView
{
    CGFloat particleRadius;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.edgeCount = 0;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.edgeCount = 0;
        self.backgroundColor = [UIColor clearColor];
        self.frame = frame;
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat k = 4.f;
    particleRadius = (width > height ? height : width) / k;
    [self setNeedsDisplay];
}

- (void)setEdgeCount:(NSUInteger)edgeCount
{
    _edgeCount = edgeCount;
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.edgeCount > 2 && self.edgeCount < 9) {
        [self drawPolygon];
    } else {
        [self drawCircle];
    }
    
    [self addGlow];
}

- (void)drawPolygon
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_color set];
    
    CGPoint points[_edgeCount];
    CGFloat addAngel = M_PI * 2 / _edgeCount;
    CGFloat angel = M_PI / 2 - addAngel / 2;
    for (int i = 0; i < _edgeCount; i ++) {
        CGFloat x = cos(angel) * particleRadius + self.frame.size.width / 2;
        CGFloat y = sin(angel) * particleRadius + self.frame.size.height / 2;
        CGFloat mod = angel - (angel / M_PI * 2) * M_PI * 2;
        if (mod > M_PI) {
            x = -x;
            y = -y;
        }
        points[i] = CGPointMake(x, y);
        angel += addAngel;
    }
    CGContextAddLines(context, points, _edgeCount);
    CGContextDrawPath(context, kCGPathFill);
}

- (void)drawCircle
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_color set];
    CGContextAddArc(context,
                    self.frame.size.width / 2,
                    self.frame.size.height / 2,
                    particleRadius,
                    0,
                    M_PI * 2,
                    0);
    CGContextDrawPath(context, kCGPathFill);
}

- (void)addGlow
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat radius = width > height ? height / 2 : width / 2;
    CGFloat alpha = 0.5 / radius;
    for (int i = 0; i < radius; i ++) {
        [[_color colorWithAlphaComponent:alpha] set];
        CGContextAddArc(context,
                        self.frame.size.width / 2,
                        self.frame.size.height / 2,
                        i,
                        0,
                        M_PI * 2,
                        0);
        CGContextDrawPath(context, kCGPathFill);
    }
}

@end
