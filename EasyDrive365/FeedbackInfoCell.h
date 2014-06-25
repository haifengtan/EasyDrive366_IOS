//
//  FeedbackInfoCell.h
//  EasyDrive366
//
//  Created by Steven Fu on 12/5/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@property (weak, nonatomic) IBOutlet UILabel *lblUsername;

@property (weak, nonatomic) IBOutlet UILabel *lblContent;


@end
