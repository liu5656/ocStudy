//
//  ViewController.m
//  AudioDemo
//
//  Created by 刘健 on 16/7/8.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *testString = @"AF1234567890";
    NSData *testData = [testString dataUsingEncoding: NSUTF8StringEncoding];
    Byte *testByte = (Byte *)[testData bytes];
    for(int i=0;i<[testData length];i++)
        printf("testByte = %d\n",testByte[i]);
    
}


@end
