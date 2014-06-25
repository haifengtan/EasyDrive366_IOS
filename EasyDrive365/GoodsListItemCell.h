//
//  GoodsListItemCell.h
//  EasyDrive366
//  产品列表cell
//  Created by Steven Fu on 12/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuyButtonDelegate.h"
#import "StrikeThroughLabel.h"


@interface GoodsListItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet StrikeThroughLabel *lblStand_price;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lblBuyer;

@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@property (nonatomic) id item;
@property (nonatomic) id<BuyButtonDelegate> delegate;
@end
