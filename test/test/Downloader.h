//
//  Downloader.h
//  fa
//
//  Created by lj on 16/3/16.
//  Copyright © 2016年 lj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZLErrMsg.h"
@interface Downloader : NSObject


- (void)download:(NSString *)url
           begin:(long long)begin
          length:(long long)length
         failure:(void (^)(CZLErrMsg *error))failureBlock
    successBlock:(void(^)(NSString *downLoadFilePath))successfulBlock
        progress:(void (^)(long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock;

- (void)start;
- (void)cancle;



@end
