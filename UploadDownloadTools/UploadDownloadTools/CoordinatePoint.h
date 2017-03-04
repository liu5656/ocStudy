//
//  CoordinatePoint.h
//  UploadDownloadTools
//
//  Created by 刘健 on 2017/3/3.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import <JSONModel/JSONModel.h>

//@protocol CoordinatePoint <NSObject>
//
//@end

@interface CoordinatePoint : JSONModel

//longitude: 123.3,
//latitude: 145.4,
//mark: "水帘洞"

@property (nonatomic, assign) float longitude;
@property (nonatomic, assign) float latitude;
@property (nonatomic, copy) NSString *mark;

@end
