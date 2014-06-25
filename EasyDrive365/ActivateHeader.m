//
//  ActivateHeader.m
//  EasyDrive366
//
//  Created by Fu Steven on 8/29/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ActivateHeader.h"

@implementation ActivateHeader

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
    if (self.delegate){
        [self.delegate buttonPressed:self.txtCode.text];
    }
}

@end
