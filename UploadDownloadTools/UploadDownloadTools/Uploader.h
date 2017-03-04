//
//  Uploader.h
//  fa
//
//  Created by lj on 16/3/17.
//  Copyright © 2016年 lj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Uploader : NSObject

- (void)upload:(NSString *)url
destinationPath:(NSString *)uploadPath
         begin:(long long)begin
           end:(long long)end
       headers:(NSMutableDictionary *)headers
       failure:(void (^)(NSError *error))failureBlock
  successBlock:(void(^)(NSString *downLoadFilePath))successfulBlock
      progress:(void (^)(long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock;

- (void)start;
- (void)cancle;

//+(void)UploadSingleFile:(NSString *)filePath;

@end
