//
//  OrderItem.h
//  EasyDrive366
//
//  Created by Steven Fu on 1/7/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderItem : NSObject
@property (nonatomic) int orderitem_id;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *price;
@property (nonatomic) NSString *stand_price;
@property (nonatomic) NSString *discount;
@property (nonatomic) NSString *buyer;
@property (nonatomic) NSString *description;
@property (nonatomic) NSString *pic_url;
@property (nonatomic) int quantity;
@property (nonatomic) int min_quantity;
@property (nonatomic) int max_quantity;
@property (nonatomic) float price_num;

-(id)initWithJson:(id)json;


@end
