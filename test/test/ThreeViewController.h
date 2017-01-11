//
//  ThreeViewController.h
//  test
//
//  Created by 刘健 on 2017/1/4.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreeViewController : UIViewController

@property (nonatomic, weak) id dekegate;

@property (nonatomic, copy) void (^callback)();

+ (instancetype)customAlertControllerTitle:(NSString *)title andMessage:(NSString *)message andButtons:(NSMutableArray *)buttons;

@end
