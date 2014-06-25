//
//  PayUseDiscountCell.h
//  EasyDrive366
//
//  Created by Steven Fu on 1/7/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PayUseDiscountCellDelegate
-(void)settingsChanged:(UITableViewCell *)cell value:(BOOL)value;
@end

@interface PayUseDiscountCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UISwitch *switchUse;
@property (nonatomic) id<PayUseDiscountCellDelegate> delegate;
@end
