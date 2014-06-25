//
//  JobItemCell.h
//  EasyDrive366
//
//  Created by Steven Fu on 3/20/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (nonatomic,weak) id job;
@property (nonatomic,weak) UINavigationController *parent;
@end
