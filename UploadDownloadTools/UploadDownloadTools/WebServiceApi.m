//
//  WebServiceApi.m
//  fa
//
//  Created by lj on 16/1/27.
//  Copyright © 2016年 lj. All rights reserved.
//

#import "WebServiceApi.h"
#import "AFNetworking.h"

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>

#define SERVER @"http://192.168.77.123:8080/WebAPI/"
#define TrafficBytes @"trafficBytes"
#define TrafficBytesStartTime @"TrafficBytesStartTime"
#define TrafficBytesEndTime @"TrafficBytesEndTime"
#define TIME_OUT    10


@interface WebServiceApi ()

/**
 *  用来写数据的文件句柄对象
 */
@property (nonatomic, strong) NSFileHandle *writeHandle;

/**
 *  文件的总长度
 */
@property (nonatomic, assign) long long totalLength;
/**
 *  当前已经写入的总大小
 */
@property (nonatomic, assign) long long  currentLength;
/**
 *  连接对象
 */
@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, weak) void (^failure)(NSString *error);
@property (nonatomic, weak) void (^successBlock)(NSString *downLoadFilePath);
@property (nonatomic, weak) void (^progress)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

@property (nonatomic, assign) int trafficBytes;
//@property (nonatomic, strong) DataTrafficPacket *trafficPacket;

@end


@implementation WebServiceApi

SHARED_SERVICE(WebServiceApi);

- (id)init {
    self = [super init];
    if (self) {
//        _isNetWork = YES;
    }
    return self;
}

+ (NSString *)urlWithServer:(NSString*)server andPath:(NSString *)path {
    NSString * url = nil;
    if (0 == path.length) {
        url = [NSString stringWithFormat:@"%@", server];
    } else {
        url = [NSString stringWithFormat:@"%@%@", server, path];
    }
    
    return url;
}

+ (NSMutableDictionary *)sortedDictionary:(NSMutableDictionary *)params ByComparisonResult:(NSComparisonResult)comparisonResult {
    NSMutableDictionary *sortedParams = [NSMutableDictionary dictionary];
    NSArray *keyArr = [params.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2] == comparisonResult;
    }];
    for (NSString *key in keyArr) {
        [sortedParams setObject:[params objectForKey:key] forKey:key];
    }
    return sortedParams;
}

- (void)getRequestWithPath:(NSString *)pathString
                    params:(NSMutableDictionary *)params
                   headers:(NSMutableDictionary *)headers
                   failure:(void (^)(CZLErrMsg *error))failure
              successBlock:(void(^)(id obj))successful {
    
    NSString *url = [WebServiceApi urlWithServer:SERVER andPath:pathString];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *tempUrlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *sortedParams = [WebServiceApi sortedDictionary:params ByComparisonResult:NSOrderedDescending];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = TIME_OUT;
    for (NSString *key in headers.allKeys) {
        [manager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
    }
    
    [manager GET:tempUrlStr parameters:sortedParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"isTrue"];
        BOOL isTrue = [number boolValue];
        
        if (isTrue) {
            id result = [responseObject objectForKey:@"result"];
            successful(result);
        }else{
            failure([self failureHandlerCenter:responseObject]);
            NSLog(@"%@",[NSString stringWithFormat:@"错误:get_%@\n错误信息:%@\n消息头:%@\n参数:%@\n",pathString,[responseObject objectForKey:@"errorMessage"],manager.requestSerializer.HTTPRequestHeaders, params]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([self failureHandlerCenter:error]);
        NSLog(@"%@",[NSString stringWithFormat:@"错误:get_%@\n错误信息:%@\n消息头:%@\n参数:%@\n",pathString,error.description,manager.requestSerializer.HTTPRequestHeaders, params]);
    }];

}

- (void)postRequestWithPath:(NSString *)pathString
                     params:(NSMutableDictionary *)params
                    headers:(NSMutableDictionary *)headers
                    failure:(void (^)(CZLErrMsg *error))failure
               successBlock:(void(^)(id obj))successful {
    if (!_isNetWork) {
        failure([[CZLErrMsg alloc] init].netWorkErr);
        return;
    }
    NSString *url = [WebServiceApi urlWithServer:SERVER andPath:pathString];
    NSString *tempUrlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *sortedParams = [WebServiceApi sortedDictionary:params ByComparisonResult:NSOrderedDescending];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = TIME_OUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [manager POST:tempUrlStr parameters:sortedParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSNumber *number = [responseObject valueForKey:@"isTrue"];
        BOOL isTrue = [number boolValue];
        
        if (isTrue) {
            id result = [responseObject objectForKey:@"result"];
            successful(result);
        }else{
            failure([self failureHandlerCenter:responseObject]);
            NSLog(@"%@",[NSString stringWithFormat:@"错误:post_%@\n错误信息:%@\n消息头:%@\n参数:%@\n",pathString,[responseObject objectForKey:@"errorMessage"],manager.requestSerializer.HTTPRequestHeaders, params]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        failure([self failureHandlerCenter:error]);
        NSLog(@"%@",[NSString stringWithFormat:@"错误:post_%@\n错误信息:%@\n消息头:%@\n参数:%@\n",pathString, error.description,manager.requestSerializer.HTTPRequestHeaders, params]);
    }];
    
}

- (void)putRequestWithPath:(NSString *)pathString
                    params:(NSMutableDictionary *)params
                   headers:(NSMutableDictionary *)headers
                   failure:(void (^)(CZLErrMsg *error))failure
              successBlock:(void(^)(id obj))successful{
    
    if (!_isNetWork) {
        failure([[CZLErrMsg alloc] init].netWorkErr);
        return;
    }
    NSString *url = [WebServiceApi urlWithServer:SERVER andPath:pathString];
    NSString *tempUrlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *sortedParams = [WebServiceApi sortedDictionary:params ByComparisonResult:NSOrderedDescending];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = TIME_OUT;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    for (NSString *key in headers.allKeys) {
        [manager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
    }
    
    [manager PUT:tempUrlStr parameters:sortedParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"isTrue"];
        BOOL isTrue = [number boolValue];
        if (isTrue) {
            id result = [responseObject objectForKey:@"result"];
            successful(result);
            NSLog(@"%@",[NSString stringWithFormat:@"成功:put_%@\n错误信息:%@\n消息头:%@\n参数:%@\n",pathString,[responseObject objectForKey:@"errorMessage"],manager.requestSerializer.HTTPRequestHeaders, params]);
        }else{
            failure([self failureHandlerCenter:responseObject]);
            NSLog(@"%@",[NSString stringWithFormat:@"错误:put_%@\n错误信息:%@\n消息头:%@\n参数:%@\n",pathString,[responseObject objectForKey:@"errorMessage"],manager.requestSerializer.HTTPRequestHeaders, params]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([self failureHandlerCenter:error]);
        NSLog(@"%@",[NSString stringWithFormat:@"错误:put_%@\n错误信息:%@\n消息头:%@\n参数:%@\n",pathString, error.description,manager.requestSerializer.HTTPRequestHeaders, params]);
    }];
}

- (void)deleteRequestWithPath:(NSString *)pathString
                    params:(NSMutableDictionary *)params
                      headers:(NSMutableDictionary *)headers
                      failure:(void (^)(CZLErrMsg *error))failure
               successBlock:(void(^)(id obj))successful {
    if (!_isNetWork) {
        failure([[CZLErrMsg alloc] init].netWorkErr);
        return;
    }
    NSString *url = [WebServiceApi urlWithServer:SERVER andPath:pathString];
    NSString *tempUrlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *sortedParams = [WebServiceApi sortedDictionary:params ByComparisonResult:NSOrderedDescending];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    for (NSString *key in headers.allKeys) {
        [manager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
    }
    
    [manager DELETE:tempUrlStr parameters:sortedParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"isTrue"];
        BOOL isTrue = [number boolValue];
        if (isTrue) {
            id result = [responseObject objectForKey:@"result"];
            successful(result);
        }else{
            failure([self failureHandlerCenter:responseObject]);
            NSLog(@"%@",[NSString stringWithFormat:@"错误:delete_%@\n错误信息:%@\n消息头:%@\n参数:%@\n",pathString,[responseObject objectForKey:@"errorMessage"],manager.requestSerializer.HTTPRequestHeaders, params]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([self failureHandlerCenter:error]);
        
        NSLog(@"错误:delete___%@___%@",pathString,error.description);
    }];
    
}

-(void)sendHttpWithBody:(NSData *)body header:(NSDictionary *)header urlPath:(NSString *) srcPath method:(NSString *) method failure:(void (^)(CZLErrMsg *error))failure
           successBlock:(void(^)(id obj))successful
{
    NSString *uploadUrl = [WebServiceApi urlWithServer:SERVER andPath:srcPath];
    uploadUrl = [uploadUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"requestURL: %@",uploadUrl);
    NSURL *url = [NSURL URLWithString:uploadUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:method];
    [request setTimeoutInterval:TIME_OUT];
    
    if (header) {
        [request setAllHTTPHeaderFields:header];
    }
    if (body) {
        [request setHTTPBody:body];
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (!jsonDict) {
                NSString *errhtml = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"error page: %@",errhtml);
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure([[CZLErrMsg alloc] init].serverReturnErr);
                });
            }else {
                NSLog(@"normal: %@",jsonDict);
                if (![[jsonDict objectForKey:@"isTrue"] boolValue]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure([self failureHandlerCenter:jsonDict]);
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        successful(data);
                    });
                }
            }
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure([[CZLErrMsg alloc] init].netWorkErr);
            });
        }
    }];
    [task resume];
}

//TODO 对大量的错误信息处理
- (CZLErrMsg *)failureHandlerCenter:(id)error
{
    NSInteger errorCode = 0;
    NSString *fromNetErr = @"";
    if ([error isKindOfClass:[NSError class]]) {
        NSError *tempError = (NSError *)error;
        errorCode = tempError.code;
    }else if ([error isKindOfClass:[NSDictionary class]]){
        NSDictionary *errorInfo = (NSDictionary *)error;
        errorCode = [[errorInfo objectForKey:@"errorCode"] integerValue];
        fromNetErr = [errorInfo objectForKey:@"errorMessage"];
    }
    
    NSString *errorStr = @"";
    switch (errorCode) {
        case NET_CAN_NOT_USE:
            errorStr = @"请检查网络后重试";
            break;
        default://未知错误
            errorStr = fromNetErr;//tocken失效
            break;
    }
    CZLErrMsg *err = [[CZLErrMsg alloc] init];
    err.errorCode = errorCode;
    err.errorMessage = errorStr;
    return err;
}

-(void)onTokenFailed
{
    
}

#pragma mark data traffic statistics
- (void)startDataTrafficStatistics
{
    
}

- (void)stopDataTrafficStatistics
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    _trafficBytes = [WebServiceApi get3GFlowIOBytes] - _trafficBytes;
    NSNumber *currentBytes =  [NSNumber numberWithLong:_trafficBytes];
    [userDefaultes setObject:currentBytes forKey:TrafficBytes];
    
    long time = [[NSDate date] timeIntervalSince1970] * 1000;
    NSNumber *number = [NSNumber numberWithLong:time];
    [userDefaultes setObject:number forKey:TrafficBytesEndTime];
    _trafficBytes = 0;
}

+(int)get3GFlowIOBytes{
    struct ifaddrs *ifa_list= 0, *ifa;
    if (getifaddrs(&ifa_list)== -1) {
        return 0;
    }
    uint32_t iBytes = 0;
    uint32_t oBytes = 0;
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        if (!(ifa->ifa_flags& IFF_UP) &&!(ifa->ifa_flags & IFF_RUNNING))
            continue;
        if (ifa->ifa_data == 0)
            continue;
        if (!strcmp(ifa->ifa_name,"pdp_ip0")) {
            struct if_data *if_data = (struct if_data*)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
            NSLog(@"%s :iBytes is %d, oBytes is %d",ifa->ifa_name, iBytes, oBytes);
        }
    }
    freeifaddrs(ifa_list);
    return iBytes + oBytes;
}

@end
