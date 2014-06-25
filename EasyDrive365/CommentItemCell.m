//
//  CommentItemCell.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/18/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "CommentItemCell.h"
#import "AMRatingControl.h"

@interface CommentItemCell(){
    AMRatingControl *_ratingView;
}

@end
@implementation CommentItemCell

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
    if (_ratingView==nil){
        _ratingView =[[AMRatingControl alloc] initWithLocation:CGPointMake(15, 75) andMaxRating:5];
        [_ratingView setRating:rating];
    
        [self addSubview:_ratingView];
        [_ratingView setEnabled:false];
        
    }
    
}


@end
