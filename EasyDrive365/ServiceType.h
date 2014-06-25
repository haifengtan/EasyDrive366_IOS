//
//  ServiceType.h
//  EasyDrive366
//
//  Created by Steven Fu on 12/11/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceType : NSObject
@property (nonatomic) Boolean checked;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *code;
-(id)initWithJson:(id)json;
@end
