//
//  GoodsListItemCell.m
//  EasyDrive366
//  产品列表cell
//  Created by Steven Fu on 12/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "GoodsListItemCell.h"

@implementation GoodsListItemCell

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
- (IBAction)buyButtonPressed:(id)sender {
    if (self.delegate){
        [self.delegate BuyButtonDelegate:self.item];
    }
}

@end
