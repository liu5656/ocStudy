//
//  ViewController.m
//  BLETest
//
//  Created by 刘健 on 2017/3/27.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "ViewController.h"
#import "CentralManager.h"

@interface ViewController ()
@property (nonatomic, strong) UILabel *netWorkLabel;
@end

@implementation ViewController

- (void)hiddenNetworkNotReachableSymbol {
    [self.netWorkLabel setHidden:YES];
}

#pragma mark get
- (UILabel *)netWorkLabel {
    if (!_netWorkLabel) {
        _netWorkLabel = [[UILabel alloc] init];
        _netWorkLabel.frame = CGRectMake(100, 25, (736 - 200), 35);
        _netWorkLabel.layer.cornerRadius = _netWorkLabel.frame.size.height * 0.5;
        _netWorkLabel.layer.masksToBounds = YES;
        
        _netWorkLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _netWorkLabel.textAlignment = NSTextAlignmentCenter;
        NSTextAttachment *attchment = [[NSTextAttachment alloc] init];
        attchment.bounds = CGRectMake(-2, -5, 20, 20);
        attchment.image = [UIImage imageNamed:@"warn_orange"];
        NSAttributedString *attriStr = [NSMutableAttributedString attributedStringWithAttachment:attchment];
        NSMutableAttributedString *mutableAttributeStr = [[NSMutableAttributedString alloc] initWithString:@"网络不可用，请检查您的网络设置!"];
        [mutableAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, mutableAttributeStr.length)];
        [mutableAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, mutableAttributeStr.length)];
        [mutableAttributeStr insertAttributedString:attriStr atIndex:0];
        _netWorkLabel.attributedText = mutableAttributeStr;
        _netWorkLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenNetworkNotReachableSymbol)];
        [_netWorkLabel addGestureRecognizer:tapGesture];
        [self.view addSubview:_netWorkLabel];
    }
    return _netWorkLabel;
}


#pragma life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [[CentralManager sharedInstance] autoConnectCurrentBindPreipheral:^(CustomPeripheral *peripheral, BLEConnectStatus status) {
        
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
