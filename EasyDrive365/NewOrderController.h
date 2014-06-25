//
//  NewOrderController.h
//  EasyDrive366
//  产品购买页面
//  Created by Steven Fu on 1/7/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewOrderController : UITableViewController

/**产品id*/
@property (nonatomic) int product_id;
/**订单id*/
@property (nonatomic) id order_id;
@property (nonatomic) int min;
@property (nonatomic) int max;
@end
