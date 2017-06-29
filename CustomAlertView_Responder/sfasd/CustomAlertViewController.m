//
//  CustomAlertViewController.m
//  sfasd
//
//  Created by 刘健 on 2017/6/27.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "CustomAlertViewController.h"
#import "CustomAlertWindow.h"
#import "ButtonHandler.h"
#import "ContainView.h"

#define LineWidth 0.3

@interface CustomAlertViewController ()


@property (nonatomic, strong) UIView *containerBGV;
@property (nonatomic, strong) ContainView *messageV;
@property (nonatomic, strong) NSMutableArray<ButtonHandler *> *handlers;
@end

@implementation CustomAlertViewController

+ (instancetype)alertWithTitle:(NSString *)title andMessage:(NSString *)message {
    CustomAlertViewController *alert = [[CustomAlertViewController alloc] initWithTitle:title andMessage:message];
    return alert;
}

+ (instancetype)alertWithTitle:(NSString *)title andMessage:(NSString *)message andActions:(NSMutableArray *)actions {
    CustomAlertViewController *alert = [self alertWithTitle:title andMessage:message];
    __weak typeof(alert) weakSelf = alert;
    for (int i = 0; i < actions.count; i++) {
        NSString *str = actions[i];
        [alert addButtonTitle:str clickBlock:^(NSInteger index) {
            [weakSelf buttonCallback:i];
        }];
    }
    return alert;
}

- (void)buttonCallback:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(customAlertViewController:andIndex:)]) {
        [self.delegate customAlertViewController:self andIndex:index];
    }
}

- (void)addButtonTitle:(NSString *)title clickBlock:(void (^)(NSInteger index))handler {
    ButtonHandler *buttonH = [ButtonHandler buttonHandlerWithTitle:title andIndex:0 andClickBlock:handler];
    [self.handlers addObject:buttonH];
}

- (void)show {
    CGFloat height = CGRectGetMaxY(self.messageV.frame) + ContainerDefaultBorder;
    if (self.handlers.count) {
        
        UIView *horLine = [[UIView alloc] initWithFrame:CGRectMake(0, height, CGRectGetMaxX(self.messageV.frame), LineWidth)];
        horLine.backgroundColor = [UIColor blackColor];
        [self.containerBGV addSubview:horLine];
        
        switch (self.handlers.count) {
            case 1:
            {
                ButtonHandler *handler = self.handlers.firstObject;
                handler.frame = CGRectMake(0, CGRectGetMaxY(horLine.frame), self.messageV.frame.size.width, ButtonHeight);
                [self.containerBGV addSubview:handler];
                height += ButtonHeight;
            }
                break;
                
            case 2:
            {
                CGFloat width = self.messageV.frame.size.width * 0.5;
                for (int i = 0; i < self.handlers.count; i++) {
                    ButtonHandler *handler = (ButtonHandler *)self.handlers[i];
                    handler.frame = CGRectMake((width + LineWidth) * i, CGRectGetMaxY(horLine.frame), width - LineWidth, ButtonHeight);
                    [self.containerBGV addSubview:handler];
                    if (i != self.handlers.count - 1) {
                        UIView *verLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(handler.frame), handler.frame.origin.y, LineWidth, handler.frame.size.height)];
                        verLine.backgroundColor = [UIColor blackColor];
                        [self.containerBGV addSubview:verLine];
                    }
                    
                }
                height += ButtonHeight;
            }
                break;
            case 3:
            {
                for (int i = 0; i < self.handlers.count; i++) {
                    ButtonHandler *handler = (ButtonHandler *)self.handlers[i];
                    handler.frame = CGRectMake(0, height + ButtonHeight * i, self.messageV.frame.size.width, ButtonHeight);
                    [self.containerBGV addSubview:handler];
                    
                    if (i != self.handlers.count - 1) {
                        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, i * ButtonHeight, self.messageV.frame.size.width, LineWidth)];
                        line.backgroundColor = [UIColor blackColor];
                        [self.containerBGV addSubview:horLine];
                    }
                    height += ButtonHeight;
                }
            }
                break;
                
            default:
                break;
        }
        
    }
    self.containerBGV.bounds = CGRectMake(0, 0, self.messageV.frame.size.width, height);
    self.containerBGV.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5);
    [[CustomAlertWindow sharedInstance] makeKeyAndVisible];
    [CustomAlertWindow sharedInstance].rootViewController = self;
}

- (void)hiddenAlertWithIndex:(NSInteger)index {
    [[CustomAlertWindow sharedInstance] revertKeyWindowAndHidden];
    [CustomAlertWindow sharedInstance].rootViewController = nil;
    if (self.handlers.count >= (index + 1)) {
        ButtonHandler *handler = [self.handlers objectAtIndex:index];
        [handler buttonClick];
    }
}

- (void)tapAction {
    [self hiddenAlertWithIndex:0];
}

#pragma mark life circle
- (instancetype)initWithTitle:(NSString *)title andMessage:(NSString *)message {
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor clearColor];
        
        self.containerBGV = [[UIView alloc] init];
        self.containerBGV.backgroundColor = [UIColor whiteColor];
        self.containerBGV.layer.cornerRadius = 10;
        self.containerBGV.layer.masksToBounds = YES;
        [self.view addSubview:self.containerBGV];
        
        self.messageV = [ContainView containViewWithTitle:title andMessage:message];
        [self.containerBGV addSubview:self.messageV];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.view.frame = [UIScreen mainScreen].bounds;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    }];
}

- (void)dealloc {
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
- (NSMutableArray<ButtonHandler *> *)handlers {
    if (!_handlers) {
        _handlers = [NSMutableArray array];
    }
    return _handlers;
}

@end
