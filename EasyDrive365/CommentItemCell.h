//
//  CommentItemCell.h
//  EasyDrive366
//
//  Created by Steven Fu on 12/18/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblAvg_stars;
@property (weak, nonatomic) IBOutlet UILabel *lblVoter_num;
@property (weak, nonatomic) IBOutlet UIProgressView *pvStar5;
@property (weak, nonatomic) IBOutlet UIProgressView *pvStar4;

@property (weak, nonatomic) IBOutlet UIProgressView *pvStar3;

@property (weak, nonatomic) IBOutlet UIProgressView *pvStar2;

@property (weak, nonatomic) IBOutlet UIProgressView *pvStar1;
@property (weak, nonatomic) IBOutlet UILabel *lblStar5;
@property (weak, nonatomic) IBOutlet UILabel *lblStar4;
@property (weak, nonatomic) IBOutlet UILabel *lblStar3;
@property (weak, nonatomic) IBOutlet UILabel *lblStar2;
@property (weak, nonatomic) IBOutlet UILabel *lblStar1;

@property (nonatomic) int rating;
@end
