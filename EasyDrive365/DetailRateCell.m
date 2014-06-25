//
//  DetailRateCell.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/11/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "DetailRateCell.h"
#import "AMRatingControl.h"

@interface DetailRateCell(){
    AMRatingControl *_ratingView;
}
@end
@implementation DetailRateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRating:(CGFloat)rating{
    if (_ratingView==nil){
        _ratingView =[[AMRatingControl alloc] initWithLocation:CGPointMake(20, 11) andMaxRating:5];
        [_ratingView setRating:rating];
        [_ratingView addTarget:self action:@selector(rated:) forControlEvents:UIControlEventEditingDidEnd];
        [self addSubview:_ratingView];
        [_ratingView setEnabled:false];
        
    }

}
-(void)rated:(AMRatingControl *)sender{
    NSLog(@"%d",[sender rating]);
}
@end
