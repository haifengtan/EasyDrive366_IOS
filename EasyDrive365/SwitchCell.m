//
//  SwitchCell.m
//  EasyDrive366
//
//  Created by Fu Steven on 4/19/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "SwitchCell.h"

@implementation SwitchCell

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
- (IBAction)switchValueChanged:(id)sender {
    if (self.delegate){
        [self.delegate switchChanged:self.switchResult cell:self];
    }
}

@end
