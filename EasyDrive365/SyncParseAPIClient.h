//
//  SyncParseAPIClient.h
//  Learn ActivityViewController
//
//  Created by Fu Steven on 1/31/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface SyncParseAPIClient : AFHTTPClient

+(SyncParseAPIClient *)sharedClient;

-(NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters;
-(NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate;

@end
