//
//  SwitchCell.h
//  EasyDrive366
//
//  Created by Fu Steven on 4/19/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SwitchCell;

@protocol SwitchCellDelegate
-(void)switchChanged:(UISwitch *)aSwitch cell:(SwitchCell *)cell;
@end

@interface SwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UISwitch *switchResult;
@property (weak,nonatomic) id<SwitchCellDelegate> delegate;
@property (weak,nonatomic) id targetObject;
@end
