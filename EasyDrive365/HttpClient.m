//
//  HttpClient.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/9/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "HttpClient.h"
#import "AFNetworking.h"
#import "AFHTTPClient.h"
#import "Reachability.h"
#import "SVProgressHUD.h"

@implementation HttpClient

+(HttpClient *)sharedHttp
{
    static HttpClient *instnace;
    static dispatch_once_t run_once;
    dispatch_once(&run_once,^{
        instnace =[[HttpClient alloc] init];
    });
    return instnace;
}
-(void)online{
    //Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    reach.reachableBlock = ^(Reachability *reach){
        NSLog(@"Internet");
        self.isInternet = YES;
    };
    reach.unreachableBlock=^(Reachability *reach){
        NSLog(@"no internet");
        self.isInternet = NO;
    };
    [reach startNotifier];
    /*
    AFHTTPClient *client =[AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [client setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status==AFNetworkReachabilityStatusNotReachable){
            //not reachable
            NSLog(@"no internet");
        }else{
            //reachable
            NSLog(@"internet");
        };
        if (status==AFNetworkReachabilityStatusReachableViaWiFi){
            // on wifi;
            NSLog(@"wifi");
        }
    }];
     */
    
    /*
    AFHTTPClient *httpClient =[[AFHTTPClient alloc] init];
    
    NSLog(@"network status=%d",httpClient.networkReachabilityStatus);
    return httpClient.networkReachabilityStatus==AFNetworkReachabilityStatusReachableViaWWAN || httpClient.networkReachabilityStatus==AFNetworkReachabilityStatusReachableViaWiFi;
     */
}
-(void)request:(NSString *)path method:(NSString *)method parameter:(NSDictionary *)parameter block:(void (^)(id json))processJson{
    [SVProgressHUD show];
    
    NSURL *url = [NSURL URLWithString:SERVERURL];
    AFHTTPClient *httpClient =[[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSMutableURLRequest *request=[httpClient requestWithMethod:method  path:path parameters:parameter];
    NSLog(@"Request=%@",request.URL);
    AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        id jsonResult =[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&error];
        //NSLog(@"get Result=%@",jsonResult);
        processJson(jsonResult);
        if (![[jsonResult objectForKey:@"status"] isEqualToString:@"success"]){
            NSString *message = @"发生异常，请稍后再试.";
            if ([[jsonResult allKeys] containsObject:@"message"]){
                message = [jsonResult objectForKey:@"message"];
            }
            [SVProgressHUD dismissWithSuccess:message afterDelay:MESSAGE_SHOW_TIME];
        }else{
            id alertMsg = jsonResult[@"alertmsg"];
            if (alertMsg && ![alertMsg isKindOfClass:[NSNull class]] && ![alertMsg isEqualToString:@""]){
                [SVProgressHUD dismissWithSuccess:alertMsg afterDelay:MESSAGE_SHOW_TIME];
            }else{
                [SVProgressHUD dismiss];
            }
        
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Access server error:%@,because %@",error,operation.request);
        [SVProgressHUD dismissWithError:@"无法连接服务器，请稍后再试!" afterDelay:3];
        
    }];
    NSOperationQueue *queue=[[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}
-(void)get:(NSString *)path block:(void (^)(id json))processJson
{
    [self request:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] method:@"GET" parameter:nil block:processJson];
}
-(void)post:(NSString *)path parameters:(NSDictionary *)parameters block:(void (^)(id json))processJson
{
    [self request:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] method:@"POST" parameter:parameters block:processJson];
}
@end
