//
//  LEConnections.m
//  four23book_client_borrower_ios
//
//  Created by Larry Emerson on 15/9/17.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEConnections.h"
#import "AFNetworking.h"
#import "AFURLResponseSerialization.h"

@implementation NSString(JSONCategories)
-(id)JSONValue {
//    NSLogObjects(self);
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}
@end
@implementation NSObject (JSONCategories)
-(NSString*)JSONString {
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error != nil || !result) return nil;
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}
@end
@implementation LEConnectionsResponseObject
-(id) initWithResponse:(id) response{
    self=[super init];
    if (response&&[response isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary*)response;
        self.error=[[dic objectForKey:@"error"] intValue];
        self.errormsg=[dic objectForKey:@"errormsg"];
        self.result=[dic objectForKey:@"result"];
    }
    return self;
}
-(id) initForJsonParseError{
    self=[super init];
    self.error=LEConnectionResponseJasonParseError;
    return self;
}
-(id) initForRequestFailure{
    self=[super init];
    self.error=LEConnectionRequestFailedError;
    return self;
}
-(id) initWithHtmlData:(id) data{
    self=[super init];
    self.error=0;
    self.result=data;
    return self;
}
@end
@implementation LEConnectionRequestObject
- (id) initRequestWithURL:(NSString *)url parameters:(NSDictionary *)parameter Delegate:(id<LEConnectionDelegate>) delegate{
//    NSLogObjects(url);
//    NSLogObjects(parameter);
    self=[super init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer= [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=nil;
        
        if(responseObject){
            dic=[[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] JSONValue];
        }
//        NSLogObjects(dic);
        if(dic) {
            LEConnectionsResponseObject *res=[[LEConnectionsResponseObject alloc] initWithResponse:dic];
            if(delegate){
                
                switch (res.error) {
                    case 0:
                        [delegate request:self ResponedWith:res];
                        break;
                    default:
                        [[LEMainViewController instance] setMessageText:res.errormsg];
                        [delegate request:self ResponedWith:res];
                        break;
                }
            }
        } else {
            NSLog(@"LEConnectionRequestObject JSON Parse Error");
            NSLogObjects(url);
            NSLogObjects( responseObject);
            if(delegate){
                if([responseObject isKindOfClass:[NSData class]]){
                    [delegate request:self ResponedWith:[[LEConnectionsResponseObject alloc] initWithHtmlData:responseObject]];
                }else{
                    [delegate request:self ResponedWith:[[LEConnectionsResponseObject alloc] initForJsonParseError]];
                    [[LEMainViewController instance] setMessageText:@"请求返回内容格式错误"];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"LEConnectionRequestObject Error: %@", error);
        if(delegate){
            [delegate request:self ResponedWith:[[LEConnectionsResponseObject alloc] initForRequestFailure]];
            [[LEMainViewController instance] setMessageText:@"请求失败，请检查网络"];
        }
    }];
    return self;
}
@end
@implementation LEConnections
static BOOL firstCallOver;
static BOOL enableNetWorkAlert;
static AFNetworkReachabilityStatus currentNetworkStatus;
static LEConnections *sharedInstance = nil;
+ (LEConnections *) instance { @synchronized(self) { if (sharedInstance == nil) {
    sharedInstance = [[self alloc] init];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        currentNetworkStatus=status;
        [NSTimer scheduledTimerWithTimeInterval:1 target:sharedInstance selector:@selector(onEnableNetworkAlert) userInfo:nil repeats:NO];
        if(enableNetWorkAlert){
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:{
                    [[LEMainViewController instance] setMessageText:@"当前网络不可用，请检查网络"];
                    break;
                }
                    //            case AFNetworkReachabilityStatusReachableViaWiFi:{
                    //                break;
                    //            }
                    //            case AFNetworkReachabilityStatusReachableViaWWAN:{
                    //                break;
                    //            }
                default:
                    break;
            }
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
} } return sharedInstance; }
+ (id) allocWithZone:(NSZone *)zone { @synchronized(self) { if (sharedInstance == nil) { sharedInstance = [super allocWithZone:zone]; return sharedInstance; } } return nil; }
+ (id) copyWithZone:(NSZone *)zone { return self; }
+ (id) mutableCopyWithZone:(NSZone *)zone { return self; }
-(void) onEnableNetworkAlert{
    enableNetWorkAlert=YES;
}
-(LEConnectionRequestObject *)requestWithURL:(NSString *)url parameters:(NSDictionary *)parameter Delegate:(id<LEConnectionDelegate>) delegate {
//    NSLogObjects(url);
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    if(firstCallOver&&currentNetworkStatus==AFNetworkReachabilityStatusNotReachable){
        if(enableNetWorkAlert){
            [[LEMainViewController instance] setMessageText:@"当前网络不可用，请检查网络"];
        }
        return nil;
    }
    firstCallOver=YES;
    return [[LEConnectionRequestObject alloc] initRequestWithURL:url parameters:parameter Delegate:delegate];
}
//+ (int)getTimeStamp:(NSDate *)date {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy.MM.dd";
//    NSString *sdate = [formatter stringFromDate:date];
//    NSDate *ndate = [formatter dateFromString:sdate];
//    return (int)ndate.timeIntervalSince1970;
//}
//+ (int)getTimeStamp {
//    return [[NSDate new] timeIntervalSince1970];
//}
@end
