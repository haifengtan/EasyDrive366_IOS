//
//  OrderConfirmationViewController.h
//  EasyDrive366
//  订单信息确认页面
//  Created by admin on 14-8-6.
//  Copyright (c) 2014年 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomEditTableViewController.h"

@interface OrderConfirmationViewController : CustomEditTableViewController
@property (nonatomic) NSString *order_id;
@property(strong,nonatomic) NSMutableDictionary* order_info;
@end
