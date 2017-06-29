//
//  CustomAlertViewController.h
//  sfasd
//
//  Created by 刘健 on 2017/6/27.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomAlertViewController;
@protocol CustomAlertViewControllerDelegate <NSObject>

- (void)customAlertViewController:(CustomAlertViewController *)alert andIndex:(NSInteger)index;

@end


@interface CustomAlertViewController : UIViewController

@property (nonatomic, weak) id<CustomAlertViewControllerDelegate> delegate;

//+ (instancetype)alertWithTitle:(NSString *)title andMessage:(NSString *)message;
//- (void)addButtonTitle:(NSString *)title clickBlock:(void (^)(NSInteger index))handler;

+ (instancetype)alertWithTitle:(NSString *)title andMessage:(NSString *)message andActions:(NSMutableArray *)actions;


- (void)show;
- (void)hiddenAlertWithIndex:(NSInteger)index;
@end
