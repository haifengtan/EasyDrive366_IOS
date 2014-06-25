//
//  BuyButtonView.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/22/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "BuyButtonView.h"

@implementation BuyButtonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)buyButtonPressed:(id)sender {
    if (self.delegate){
        [self.delegate buyButtonPressed:self data:self.data];
    }
}
@end
