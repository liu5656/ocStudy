//
//  VideoInfo.h
//  UploadDownloadTools
//
//  Created by 刘健 on 2017/3/3.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CoordinatePoint.h"


@interface VideoInfo : JSONModel

@property (nonatomic, assign) long long filesize;
@property (nonatomic, copy) NSString *range;
@property (nonatomic, copy) NSString *fileid;
@property (nonatomic, strong) CoordinatePoint *pointstart;
@property (nonatomic, strong) CoordinatePoint *pointend;
@property (nonatomic, assign) long long timestart;
@property (nonatomic, assign) long long timeend;


/*上传器需要的*/
@property (nonatomic, copy) NSString<Optional> *path;
@property (nonatomic, assign) long long curUploLocation;


@end
