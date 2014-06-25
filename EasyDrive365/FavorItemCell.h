//
//  FavorItemCell.h
//  EasyDrive366
//
//  Created by Steven Fu on 2/7/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavorItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagePic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblOccur_time;
@end
