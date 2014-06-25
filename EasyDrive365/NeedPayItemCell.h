//
//  NeedPayItemCell.h
//  EasyDrive366
//
//  Created by Steven Fu on 1/8/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NeedPayItemCellDelegate
-(void)payButtonPressed:(id)orderItem;
-(void)swipeRight:(UITableViewCell *)cell orderItem:(id)orderItem;
@end

@interface NeedPayItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imagePicture;
@property (weak, nonatomic) IBOutlet UIButton *btnPay;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblQuantity;
@property (nonatomic) id orderItem;
@property (nonatomic) id<NeedPayItemCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblOrder_id;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@end
