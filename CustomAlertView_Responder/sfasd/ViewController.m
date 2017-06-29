//
//  ViewController.m
//  sfasd
//
//  Created by 刘健 on 2017/6/23.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "ViewController.h"
#import "CustomAlertViewController.h"

@interface ViewController ()<CustomAlertViewControllerDelegate>

@property (nonatomic, assign) CALayer *layer;
@property (nonatomic, assign) CALayer *layer2;
@property (nonatomic, strong) UIView *torus;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(200, 100, 100, 50);
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"按钮" forState:UIControlStateNormal];
    
    button.backgroundColor = [UIColor greenColor];
    UIBezierPath *path=[UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *masklayer=[[CAShapeLayer alloc] init];//创建shapelayer
    _layer2 = masklayer;
    masklayer.frame=button.bounds;
    masklayer.path=path.CGPath;//设置路径
    button.layer.mask=masklayer;

    CGFloat borderWidth = 2.0f;
    CGFloat radius = 10.0f;
    
    CALayer * temp = [CALayer layer];
    _layer = temp;
    [temp setBackgroundColor:[UIColor whiteColor].CGColor];
    temp.frame = CGRectMake(borderWidth, borderWidth, button.bounds.size.width - borderWidth * 2, button.bounds.size.height - borderWidth * 2);
    
    UIBezierPath * subPath = [UIBezierPath bezierPathWithRoundedRect:temp.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(radius - borderWidth, radius - borderWidth)];
    CAShapeLayer * subMask  = [[CAShapeLayer alloc] initWithLayer:temp];
    subMask.path = subPath.CGPath;
    temp.mask = subMask;
    
    [button.layer addSublayer:temp];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIView *torus = [[UIView alloc] initWithFrame:CGRectMake(200, 300, 100, 100)];
    _torus = torus;
    torus.backgroundColor = [UIColor greenColor];
    [self.view addSubview:torus];

    UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:torus.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *mask1 = [[CAShapeLayer alloc] init];
    mask1.path = path1.CGPath;
    torus.layer.mask = mask1;
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(borderWidth, borderWidth, torus.bounds.size.width - 2 * borderWidth, torus.bounds.size.height - 2 * borderWidth) byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
    CALayer *layer2 = [CALayer layer];
    layer2.backgroundColor = [[UIColor whiteColor] CGColor];
    layer2.frame = torus.bounds;
    
    CAShapeLayer *mask2 = [[CAShapeLayer alloc] initWithLayer:layer2];
    mask2.path = path2.CGPath;
    
    layer2.mask = mask2;
    [torus.layer addSublayer:layer2];
    
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = torus.frame;
    button2.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 setTitle:@"按钮" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
}

- (void)buttonAction:(UIButton *)sender {
    _torus.hidden = !_torus.hidden;
//    [_layer removeFromSuperlayer];
//    [_layer2 removeFromSuperlayer];
//    sender.backgroundColor = [UIColor whiteColor];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)CustomAlertAction:(UIButton *)sender {
    CustomAlertViewController *alert = [CustomAlertViewController alertWithTitle:@"提示" andMessage:@"这fghjksdfghjklsdfghjk这fghjksdfghjklsdfghjk这fghjksdfghjklsdfghjk这fghjksdfghjklsdfghjk这fghjksdfghjklsdfghjk这fghjksdfghjklsdfghjk这fghjksdfghjklsdfghjk这fghjksdfghjklsdfghjk这fghjksdfghjklsdfghjk这fghjksdfghjklsdfghjk这fghjksdfghjklsdfghjk这fghjksdfghjklsdfghjk这fghjksdfghjklsdfghjkl" andActions:@[@"取消",@"确定"]];
    alert.delegate = self;
    [alert show];
}

- (void)customAlertViewController:(CustomAlertViewController *)alert andIndex:(NSInteger)index {
    NSLog(@"%d",index);
}


@end
