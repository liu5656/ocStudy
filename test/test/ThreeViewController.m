//
//  ThreeViewController.m
//  test
//
//  Created by 刘健 on 2017/1/4.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "ThreeViewController.h"
#import "TwoViewController.h"

@interface ThreeViewController ()

@property  (nonatomic, strong) UIView *contentV;

@end

@implementation ThreeViewController

+ (instancetype)customAlertControllerTitle:(NSString *)title andMessage:(NSString *)message andButtons:(NSMutableArray *)buttons
{
    ThreeViewController *vc = [[ThreeViewController alloc] init];
    
    return vc;
}

#pragma mark life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blackColor];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button  addTarget:self action:@selector(backaction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self backaction:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backaction:(id)sender {
    TwoViewController *vc = self.dekegate;
//    _callback();
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark get
- (UIView *)contentV
{
    if (!_contentV) {
        CGFloat width = 200;
        CGFloat height = 100;
        CGSize size = [UIScreen mainScreen].bounds.size;
        CGFloat x = (size.width - width) * 0.5;
        CGFloat y = (size.height - height) * 0.5;
        _contentV = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _contentV.layer.cornerRadius = 10;
        _contentV.layer.masksToBounds = YES;
        [self.view addSubview:_contentV];
    }
    return _contentV;
}

@end
