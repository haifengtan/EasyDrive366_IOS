//
//  HelpHeaderView.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/24/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "HelpHeaderView.h"

@implementation HelpHeaderView

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
- (IBAction)buttonPressed:(id)sender {
    NSLog(@"I am pressed!");
}

@end
