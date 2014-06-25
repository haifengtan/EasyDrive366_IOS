//
//  ProviderListItemCell.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/11/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ProviderListItemCell.h"
#import "AMRatingControl.h"


@interface ProviderListItemCell(){
    AMRatingControl *_ratingControl;
}
@end


@implementation ProviderListItemCell

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

-(void)setRating:(int)rating{
    if (!_ratingControl){
        _ratingControl =[[AMRatingControl alloc] initWithLocation:CGPointMake(140, 85) andMaxRating:5];
        [_ratingControl setRating:rating];
        [self addSubview:_ratingControl];
        [_ratingControl setEnabled:NO];
    }
}
@end
