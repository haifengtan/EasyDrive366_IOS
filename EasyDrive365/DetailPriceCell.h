//
//  DetailPriceCell.h
//  EasyDrive366
//
//  Created by Steven Fu on 12/11/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StrikeThroughLabel.h"
@interface DetailPriceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblBuyer;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscount;
@property (weak, nonatomic) IBOutlet StrikeThroughLabel *lblStand_price;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;

@end
