//
//  MenuItem.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/6/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem
-(id)initWithName:(NSString *)name title:(NSString *)title description:(NSString *)description imagePath:(NSString *)imagePath phone:(NSString *)phone
{
    self =[super init];
    if (self)
    {
        self.name = name;
        self.title = title;
        self.description = description;
        self.imagePath = imagePath;
        self.phone = phone;
    }
    return self;
}
@end
