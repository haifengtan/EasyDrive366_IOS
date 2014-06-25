//
//  BrandItemCell.h
//  EasyDrive366
//
//  Created by Steven Fu on 4/14/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblBrand;
@property (weak, nonatomic) IBOutlet UILabel *lblBrand_id;

@property (weak, nonatomic) IBOutlet UILabel *lblExhause;
@property (weak, nonatomic) IBOutlet UILabel *lblPassengers;
@property (weak, nonatomic) IBOutlet UILabel *lblModel;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@end
