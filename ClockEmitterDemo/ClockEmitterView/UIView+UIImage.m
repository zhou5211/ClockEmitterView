//
//  UIView+UIImage.m
//  emitterTest
//
//  Created by zhourx5211 on 14-8-22.
//  Copyright (c) 2014年 zhourx5211. All rights reserved.
//

#import "UIView+UIImage.h"

@implementation UIView (UIImage)

- (UIImage *)imageWithUIView:(UIView *)view {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    //[view.layer drawInContext:currnetContext];
    [view.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return image;
}

@end
