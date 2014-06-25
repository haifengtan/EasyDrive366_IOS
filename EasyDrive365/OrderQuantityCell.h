//
//  OrderQuantityCell.h
//  EasyDrive366
//
//  Created by Steven Fu on 1/7/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OrderQuantityCellDelegate
-(void)quantityChanged:(UITableViewCell *)cell value:(int)value;
@end

@interface OrderQuantityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblQuantity;
@property (nonatomic) id<OrderQuantityCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@end
