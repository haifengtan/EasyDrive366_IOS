//
//  JobItemCell.m
//  EasyDrive366
//
//  Created by Steven Fu on 3/20/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "JobItemCell.h"
#import "JobDetailController.h"

@implementation JobItemCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)detailButtonPressed:(id)sender {
    JobDetailController *vc = [[JobDetailController alloc] initWithNibName:@"JobDetailController" bundle:nil];
    
    vc.job_id = [self.job[@"id"] intValue];
    [self.parent pushViewController:vc animated:YES];
    
}

@end
