//
//  ServiceType.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/11/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ServiceType.h"

@implementation ServiceType
-(id)initWithJson:(id)json{
    self = [super init];
    if (self){
        self.code = json[@"code"];
        self.name = json[@"name"];
        self.checked = NO;
    }
    return self;
}
@end
