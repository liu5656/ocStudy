
//
//  TwoViewController.m
//  test
//
//  Created by 刘健 on 2017/1/4.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "TwoViewController.h"

#import "ThreeViewController.h"

@interface TwoViewController ()

@end

@implementation TwoViewController

#pragma mark life circle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_shouldBack) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (IBAction)backaction:(UIButton *)sender {
    ThreeViewController *vc = [[ThreeViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    self.definesPresentationContext = YES;
    vc.dekegate = self;
    
    vc.callback = ^(){
//        [self.navigationController popViewControllerAnimated:YES];
        
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
//            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:NO completion:nil];
        }
        
    };
    
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end
