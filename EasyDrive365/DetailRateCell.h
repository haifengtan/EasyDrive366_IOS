//
//  DetailRateCell.h
//  EasyDrive366
//
//  Created by Steven Fu on 12/11/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailRateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblStar;
@property (weak, nonatomic) IBOutlet UILabel *lblStar_voternum;

@property (nonatomic) CGFloat rating;
@end
