//
//  ViewController.m
//  ClockEmitterDemo
//
//  Created by zhourx5211 on 14-8-23.
//  Copyright (c) 2014年 zhourx5211. All rights reserved.
//

#import "ViewController.h"
#import "ClockEmitterView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blackColor];
    CGPoint center = CGPointMake(160, 200);
    
    ClockEmitterView *view1 = [[ClockEmitterView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    view1.center = center;
    view1.roundTime = 30;
    view1.edgeCount = 4;
    view1.color = [UIColor colorWithRed:45.f / 255.f
                                  green:233.f / 255.f
                                   blue:231.f / 255.f
                                  alpha:1];
    [self.view addSubview:view1];
    
    ClockEmitterView *view2 = [[ClockEmitterView alloc] initWithFrame:CGRectMake(0, 0, 240, 240)];
    view2.center = center;
    view2.roundTime = 15;
    [self.view addSubview:view2];
    
    ClockEmitterView *view3 = [[ClockEmitterView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    view3.center = center;
    view3.roundTime = 45;
    view3.edgeCount = 6;
    view3.color = [UIColor colorWithRed:43.f / 255.f
                                  green:251.f / 255.f
                                   blue:159.f / 255.f
                                  alpha:1];
    [self.view addSubview:view3];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
