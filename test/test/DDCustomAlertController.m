//
//  DDCustomAlertController.m
//  test
//
//  Created by 刘健 on 2017/1/5.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "DDCustomAlertController.h"
#import <objc/runtime.h>
@interface DDCustomAlertController ()

@end

@implementation DDCustomAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    unsigned int count;
    Ivar *ivars =  class_copyIvarList([UIAlertAction class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char * cName =  ivar_getName(ivar);
        NSString *ocName = [NSString stringWithUTF8String:cName];
        NSLog(@"%@",ocName);
    }
    free(ivars);
    
    
    UIView *xxx = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    xxx.backgroundColor = [UIColor clearColor];
    xxx.layer.cornerRadius = 10;
    xxx.layer.borderColor = [[UIColor redColor] CGColor];
    xxx.layer.borderWidth = 2;
    [self.view addSubview:xxx];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"%s", __func__);
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
