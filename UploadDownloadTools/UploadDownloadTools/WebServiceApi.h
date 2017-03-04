//
//  WebServiceApi.h
//  fa
//
//  Created by lj on 16/1/27.
//  Copyright © 2016年 lj. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "CZLErrMsg.h"

//创建单例
#ifndef SHARED_SERVICE
#define SHARED_SERVICE(ServiceName) \
+(instancetype)sharedInstance \
{ \
static ServiceName * sharedInstance; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
sharedInstance = [[ServiceName alloc] init]; \
}); \
return sharedInstance; \
}
#endif
// 服务器地址（内网）
//#define SERVER @"http://192.168.13.200:8080/WebAPI/"
//公网服务器
//#define SERVER @"http://183.221.3.245:8090/WebAPI/"

//#define SERVER @"http://192.168.20.187:8080/WebAPI/"


@interface WebServiceApi : NSObject

@property (nonatomic, assign) BOOL isNetWork;

+ (instancetype)sharedInstance;

// 账号在另一台设备上登录的时候
- (void)onTokenFailed;

/**
 *  拼接路径
 */
+ (NSString *)urlWithServer:(NSString*)server andPath:(NSString *)path;


/**
 *  get/post/put/delete
 *
 *  @param pathString 资源路径
 *  @param params     请求参数
 *  @param headers    消息头
 *  @param failure    失败回调块
 *  @param successful 成功回调块
 */
- (void)getRequestWithPath:(NSString *)pathString
                    params:(NSMutableDictionary *)params
                   headers:(NSMutableDictionary *)headers
                   failure:(void (^)(CZLErrMsg *error))failure
              successBlock:(void(^)(id obj))successful;

- (void)postRequestWithPath:(NSString *)pathString
                     params:(NSMutableDictionary *)params
                    headers:(NSMutableDictionary *)headers
                    failure:(void (^)(CZLErrMsg *error))failure
               successBlock:(void(^)(id obj))successful;
//- (void)postRequestWithImagePath:(NSString *)pathString
//                     params:(NSMutableDictionary *)params
//                    headers:(NSMutableDictionary *)headers
//                    failure:(void (^)(CZLErrMsg *error))failure
//               successBlock:(void(^)(id obj))successful;
- (void)putRequestWithPath:(NSString *)pathString
                    params:(NSMutableDictionary *)params
                   headers:(NSMutableDictionary *)headers
                   failure:(void (^)(CZLErrMsg *error))failure
              successBlock:(void(^)(id obj))successful;

- (void)deleteRequestWithPath:(NSString *)pathString
                       params:(NSMutableDictionary *)params
                      headers:(NSMutableDictionary *)headers
                      failure:(void (^)(CZLErrMsg *error))failure
                 successBlock:(void(^)(id obj))successful;


-(void)sendHttpWithBody:(NSData *)body
                 header:(NSDictionary *)header
                urlPath:(NSString *) srcPath
                 method:(NSString *) method
                failure:(void (^)(CZLErrMsg *error))failure
           successBlock:(void(^)(id obj))successful;
///**
// *  下载
// *
// *  @param url           资源路径
// *  @param params        参数
// *  @param headers       消息头
// *  @param failure       失败回调
// *  @param successful    成功回调
// *  @param progressBlock 进度回调
// *
// *  @return 返回下载操作对象
// */
//- (AFHTTPRequestOperation *)download:(NSString *)url
//                               params:(NSMutableDictionary *)params
//                              headers:(NSMutableDictionary *)headers
//                              failure:(void (^)(CZLErrMsg *error))failure
//                         successBlock:(void(^)(NSString *downLoadFilePath))successful
//                             progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock;
//
///**
// *  上传
// *
// *  @param url           资源路径
// *  @param filepath      上传资源在本地所在路径
// *  @param params        参数
// *  @param headers       消息头
// *  @param failure       失败回调
// *  @param successful    成功回调
// *  @param progressBlock 进度回调
// *
// *  @return 返回上传操作对象
// */
//- (AFHTTPRequestOperation *)upload:(NSString *)url
//                          filePath:(NSString *)filepath
//                            params:(NSMutableDictionary *)params
//                           headers:(NSMutableDictionary *)headers
//                           failure:(void (^)(CZLErrMsg *error))failure
//                      successBlock:(void(^)(id obj))successful
//                          progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock;


- (void)startDataTrafficStatistics;
- (void)stopDataTrafficStatistics;





@end
