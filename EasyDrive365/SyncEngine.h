//
//  SyncEngine.h
//  Learn ActivityViewController
//
//  Created by Fu Steven on 1/31/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncEngine : NSObject

@property (atomic,readonly) BOOL syncInProgress;

+(SyncEngine *)sharedEngine;
-(void)registerNSManagedObjectClassToSync:(Class)aClass;
-(void)startSync;
@end
