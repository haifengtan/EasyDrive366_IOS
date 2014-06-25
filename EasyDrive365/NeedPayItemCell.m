//
//  NeedPayItemCell.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/8/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "NeedPayItemCell.h"

@implementation NeedPayItemCell

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

- (IBAction)payButtonPressed:(id)sender {
    if (self.delegate){
        [self.delegate payButtonPressed:self.orderItem];
    }
}
- (IBAction)swipeRight:(id)sender {
    if (self.delegate){
        [self.delegate swipeRight:self orderItem:self.orderItem];
    }
}

@end
