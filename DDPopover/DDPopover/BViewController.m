//
//  BViewController.m
//  DDPopover
//
//  Created by 刘健 on 2016/12/5.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import "BViewController.h"

@interface BViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.navigationController.interactivePopGestureRecognizer);
    
    
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark 重写左侧滑动返回
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count > 1) {
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
