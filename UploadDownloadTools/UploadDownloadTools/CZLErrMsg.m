//
//  CZLErrMsg.m
//  chezhilian
//
//  Created by 王凡 on 16/5/4.
//  Copyright © 2016年 Chengdu Chezhilian Technology Co., Ltd. All rights reserved.
//

#import "CZLErrMsg.h"

@implementation CZLErrMsg

-(CZLErrMsg *)netWorkErr{
    CZLErrMsg *err = [[CZLErrMsg alloc] init];
    err.errorCode = NET_CAN_NOT_USE;
    err.errorMessage = @"请检查网络后重试";
    return err;
}

-(CZLErrMsg *)serverReturnErr{
    CZLErrMsg *err = [[CZLErrMsg alloc] init];
    err.errorCode = -2;
    err.errorMessage = @"服务器数据异常";
    return err;
}

@end
