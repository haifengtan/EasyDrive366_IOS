//
//  OrderQuantityCell.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/7/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "OrderQuantityCell.h"

@implementation OrderQuantityCell

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
- (IBAction)stepChanged:(UIStepper *)sender {
    int v = [sender value];

    self.lblQuantity.text=[NSString stringWithFormat:@"%d",v];
    if (self.delegate){
        [self.delegate quantityChanged:self value:v];
    }
}

@end
