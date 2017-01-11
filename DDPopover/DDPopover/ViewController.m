//
//  ViewController.m
//  DDPopover
//
//  Created by 刘健 on 16/9/21.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate>
{
    long angle;
}

@property (nonatomic, strong) UIView *redView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    _redView = redView;
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
    
//    [self startAnimation]; // 重复自旋转360
//    [self rotate360Repeat]; // 重复自旋转360
    
    
}



- (IBAction)leftButtonAction:(UIButton *)sender {
}




#pragma mark 重复自旋转方法
-(void) startAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    _redView.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}

-(void)endAnimation
{
    angle += 10;
    [self startAnimation];
}


- (void)rotate360Repeat
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 0.5;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = 1000;
    [self.redView.layer addAnimation:animation forKey:nil];
}
@end
