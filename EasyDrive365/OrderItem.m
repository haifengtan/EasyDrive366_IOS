//
//  OrderItem.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/7/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "OrderItem.h"

@implementation OrderItem

-(id)initWithJson:(id)json{
    self = [super init];
    if (self){
        self.orderitem_id = [json[@"id"] intValue];
        self.name =json[@"name"];
        self.price = json[@"price"];
        self.stand_price = json[@"stand_price"];
        self.discount = json[@"discount"];
        self.buyer = json[@"buyer"];
        self.description = json[@"description"];
        self.pic_url = json[@"pic_url"];
        self.quantity =[json[@"quantity"] intValue];
        self.min_quantity =[json[@"min_quantity"] intValue];
        self.max_quantity = [json[@"max_quantity"] intValue];
        self.price_num =[json[@"price_num"] floatValue];
    }
    return self;
}

@end
