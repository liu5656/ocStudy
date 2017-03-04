//
//  VideoUploader.h
//  UploadDownloadTools
//
//  Created by 刘健 on 2017/3/4.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "VideoInfo.h"

@interface VideoUploader : JSONModel


- (void)upload:(NSString *)urlPath
destinationVideo:(VideoInfo *)uploadPath
       failure:(void (^)(NSError *error, VideoInfo *video))failureBlock
  successBlock:(void(^)(NSString *downLoadFilePath, VideoInfo *video))successfulBlock
      progress:(void (^)(long long totalBytesWritten, long long totalBytesExpectedToWrite, VideoInfo *video))progressBlock;


- (void)resume;
- (void)suspend;

@end
