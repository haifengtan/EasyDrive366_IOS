//
//  OrderContentController2.h
//  EasyDrive366
//  完善保险信息页面
//  Created by admin on 14-8-1.
//  Copyright (c) 2014年 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomEditTableViewController.h"

@interface OrderContentController2 : CustomEditTableViewController
@property (nonatomic) NSString *order_id;
@property (nonatomic) int goods_id;
@property (nonatomic) id ins_data;

@end
