//
//  OneButtonCell.m
//  EasyDrive365
//
//  Created by Fu Steven on 3/8/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "OneButtonCell.h"

@implementation OneButtonCell

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
- (IBAction)buttonPress:(id)sender {
    if (self.delegate){
        [self.delegate buttonPress:self];
    }
}
-(void)setupButtonWithType:(int)type{
    if (type==0){
        self.button.textColor = [UIColor whiteColor];
        self.button.textShadowColor = [UIColor darkGrayColor];
        self.button.tintColor = [UIColor colorWithRed:(CGFloat)120/255 green:0 blue:0 alpha:1];
        self.button.highlightedTintColor = [UIColor colorWithRed:(CGFloat)190/255 green:0 blue:0 alpha:1];
    }
}
@end
