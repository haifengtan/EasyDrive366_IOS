//
//  MenuItem.h
//  EasyDrive365
//
//  Created by Fu Steven on 2/6/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *imagePath;
@property (nonatomic,copy) NSString *description;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *phone;


-(id)initWithName:(NSString *)name title:(NSString *)title description:(NSString *)description imagePath:(NSString *)imagePath  phone:(NSString *)phone;


@end
