//
//  Mp3EncodeOperation.h
//  AudioDemo
//
//  Created by 刘健 on 16/8/17.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mp3EncodeOperation : NSOperation

@property (nonatomic, assign) BOOL setToStopped;
@property (nonatomic, assign) NSMutableArray *recordQueue;
@end
