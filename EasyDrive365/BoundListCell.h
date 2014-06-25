//
//  BoundListCell.h
//  EasyDrive366
//
//  Created by Steven Fu on 12/19/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoundListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblBound;
@property (weak, nonatomic) IBOutlet UILabel *lblLeft;

@property (weak, nonatomic) IBOutlet UILabel *lblMemo;
@end
