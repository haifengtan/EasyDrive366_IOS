//
//  CommentListCell.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/18/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "CommentListCell.h"
#import "AMRatingControl.h"

@interface CommentListCell(){
    AMRatingControl *_ratingView;
}

@end
@implementation CommentListCell

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
        _ratingView =[[AMRatingControl alloc] initWithLocation:CGPointMake(200, 3) andMaxRating:5];
        [_ratingView setRating:rating];

        [self addSubview:_ratingView];
        [_ratingView setEnabled:false];
        
    }
    
}
@end
