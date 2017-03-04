//
//  UserInfo.h
//  chezhilian
//
//  Created by lj on 16/3/2.
//  Copyright © 2016年 Chengdu Chezhilian Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject<NSCoding>

@property (nonatomic, copy) NSString   *city;
@property (nonatomic, copy) NSString   *logoid;
@property (nonatomic, copy) NSString   *logourl;
@property (nonatomic, copy) NSString   *userid;
@property (nonatomic, copy) NSString   *username;
@property (nonatomic, copy) NSString   *mobile;
@property (nonatomic, copy) NSString   *phoneid;
@property (nonatomic, assign) NSNumber *rank;          //rank为0表示是非注册用户，1表示注册用户，2表示购买了基座产品的用户
@property (nonatomic, assign) BOOL      isLogined;
@property (nonatomic, copy) NSString   *token;
@property (nonatomic, copy) NSString   *registerid;
@property (nonatomic, strong) UIImage  *avatar;
@property (nonatomic, copy) NSString     *gender;
@property (nonatomic, copy) NSString *introduction;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *bleidentify;
@property (nonatomic, copy) NSString *blePower;
@property (nonatomic, copy) NSString *bleSoftVersion;
@property (nonatomic, copy) NSString *bleSerialNumber;

+(instancetype)sharedInstance;

- (void)saveUserInfo;
- (void)deleteUserInfo;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;


- (void)getUserId;


@end
