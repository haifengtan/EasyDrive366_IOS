//
//  SyncEngine.m
//  Learn ActivityViewController
//
//  Created by Fu Steven on 1/31/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "SyncEngine.h"
#import "SyncParseAPIClient.h"
#import "AFHTTPRequestOperation.h"
#import <CoreData/CoreData.h>

@interface SyncEngine()
@property (nonatomic,strong) NSMutableArray *registeredClassesToSync;
@end

@implementation SyncEngine
@synthesize syncInProgress = _syncInProgress;
+(SyncEngine *)sharedEngine
{
    static SyncEngine *sharedEngine;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedEngine = [[SyncEngine alloc] init];
    });
    return sharedEngine;
}
-(void)registerNSManagedObjectClassToSync:(Class)aClass
{
    if (!self.registeredClassesToSync)
    {
        self.registeredClassesToSync = [NSMutableArray array];
        
    }
    if ([aClass isSubclassOfClass:[NSManagedObject class]])
    {
        if (![self.registeredClassesToSync containsObject:NSStringFromClass(aClass)])
        {
            [self.registeredClassesToSync addObject:NSStringFromClass(aClass)];
        }
        
    }
}
-(NSDate *)mosRecentUpdatedAtDateForEntityWithName:(NSString *)entityName
{
    __block NSDate *date  =nil;
    /*
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]]];
    [request setFetchLimit:1];
    
    
    [[[SDCoreDataController sharedInstance] backgroundManagedObjectContext] performBlockAndWait:^{
        NSError *error = nil;
        NSArray *results = [[[SDCoreDataController sharedInstance] backgroundManagedObjectContext] executeFetchRequest:request error:&error];
        if ([results lastObject])
        {
            date = [[results lastObject] valueForKey:@"updatedAt"];
        }
    }];
     */
    date =[NSDate date];
    return date;
}
-(void)downloadDataForRegisteredObjects:(BOOL)useUpdatedAtDate
{
    NSMutableArray *operations = [NSMutableArray array];
    for (NSString *className in self.registeredClassesToSync) {
        NSDate *mostRecentUpdateDate = nil;
        if (useUpdatedAtDate)
        {
            mostRecentUpdateDate = [self mosRecentUpdatedAtDateForEntityWithName:className];
        }
        NSMutableURLRequest *request =[[SyncParseAPIClient sharedClient] GETRequestForAllRecordsOfClass:className updatedAfterDate:mostRecentUpdateDate];
        AFHTTPRequestOperation *operation = [[SyncParseAPIClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]])
            {
                NSLog(@"Response from %@:%@",className,responseObject);
                [self writeJSONResponse:responseObject toDiskForClassWithName:className];
            }else{
                NSLog(@"%@",NSStringFromClass([responseObject class]));
                NSLog(@"%@",[[operation request] allHTTPHeaderFields]);
                NSLog(@"%@",[[operation response] allHeaderFields]);
                NSLog(@"%@",[operation responseData]);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failure,Error:%@",error);
        }];
        [operations addObject:operation];
    }
    [[SyncParseAPIClient sharedClient] enqueueBatchOfHTTPRequestOperations:operations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        NSLog(@"index=%i/%i",numberOfFinishedOperations,totalNumberOfOperations);
    } completionBlock:^(NSArray *operations) {
        NSLog(@"done.");
    }];
}
-(void)startSync
{
    if (!self.syncInProgress)
    {
        [self willChangeValueForKey:@"syncInProgress"];
        _syncInProgress = YES;
        [self didChangeValueForKey:@"syncInProgress"];
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self downloadDataForRegisteredObjects:NO];
        });
        
        
    }
}
-(NSURL *)applicationCacehDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}
-(NSURL *)JSONDataRecordsDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *url = [NSURL URLWithString:@"JSONRecords/" relativeToURL:[self applicationCacehDirectory]];
    NSError *error = nil;
    if (![fileManager fileExistsAtPath:[url path]])
    {
        [fileManager createDirectoryAtPath:[url path] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    return url;
    
}
-(void)writeJSONResponse:(id)response toDiskForClassWithName:(NSString *)className
{
    NSURL *fileURL = [NSURL URLWithString:className relativeToURL:[self JSONDataRecordsDirectory]];
    // NSError *error = nil;
    if (![(NSDictionary *)response writeToFile:[fileURL path] atomically:YES])
    {
        NSLog(@"Error saving response to disk, will attempt to remove nsnull values and try again.");
        NSArray *records = [response objectForKey:@"results"];
        NSMutableArray *nullFreeRecords = [NSMutableArray array];
        for(NSDictionary *record in records)
        {
            NSMutableDictionary *nullFreeRecod = [NSMutableDictionary dictionaryWithDictionary:record];
            [record enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if ([obj isKindOfClass:[NSNull class]])
                {
                    [nullFreeRecod setValue:nil forKey:key];
                }
            }];
            [nullFreeRecords addObject:nullFreeRecod ];
        }
        NSDictionary *nullFreeDictionary = [NSDictionary dictionaryWithObject:nullFreeRecords forKey:@"results"];
        if (![nullFreeDictionary writeToFile:[fileURL path] atomically:YES])
        {
            NSLog(@"Failed all attempts to save response to disk:%@",response);
        }
        
    }
}

@end
