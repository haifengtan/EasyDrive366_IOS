//
//  SyncParseAPIClient.m
//  Learn ActivityViewController
//
//  Created by Fu Steven on 1/31/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "SyncParseAPIClient.h"
#import "AFJSONRequestOperation.h"
static NSString * const kParseAPIBaseURLString = @"http://192.168.1.105/site/pm/admin/";
static NSString * const kParseAPIApplicationId = @"GA2SdYp15sBTw2jWbEl2GdNWQFN4FNOIhMwhdlGB";
static NSString * const kParseAPIKey = @"toi46BRrfwjrk5El9tjf2hGmvhPI3cF6r2OssHTz";

@implementation SyncParseAPIClient


+(SyncParseAPIClient *)sharedClient
{
    static SyncParseAPIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedClient = [[SyncParseAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kParseAPIBaseURLString]];
    });
    return sharedClient;
    
}
-(id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self)
    {
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setParameterEncoding:AFJSONParameterEncoding];
        // set up iauth information
       // [self setDefaultHeader:@"X-Parse-Application-Id" value:kParseAPIApplicationId];
       // [self setDefaultHeader:@"X-Parse-REST-API-Key" value:kParseAPIKey];
    }
    return self;
}
-(NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *request = nil;
    request =[self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"get_content?tablename=%@",className] parameters:parameters];
    NSLog(@"%@",request);
    return request;
}
-(NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate
{
    NSMutableURLRequest *request = nil;
    NSDictionary *parameters  = nil;
    if (updatedDate)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T' HH:MM:ss.'999Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        NSString *jsonString = [NSString
                                stringWithFormat:@"{\"updatedAt\":{\"$gte\":{\"__type\":\"Date\",\"iso\":\"%@\"}}}",
                                [dateFormatter stringFromDate:updatedDate]];
        
        parameters = [NSDictionary dictionaryWithObject:jsonString forKey:@"where"];
    }
    
    request = [self GETRequestForClass:className parameters:parameters];
     NSLog(@"%@",request);
    return request;
}
@end