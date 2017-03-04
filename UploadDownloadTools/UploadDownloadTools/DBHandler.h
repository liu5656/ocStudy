//
//  DBHandler.h
//  dataBases
//
//  Created by 王凡 on 16/5/30.
//  Copyright © 2016年 王凡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"


@interface DBHandler : NSObject


@property (strong,nonatomic)FMDatabase *db;
+(instancetype) getInstance;

@end
