//
//  ArticleListItem2Cell.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/15/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "ArticleListItem2Cell.h"
#import "AppSettings.h"

@implementation ArticleListItem2Cell

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

- (IBAction)favorBtnPressed:(id)sender {
    NSLog(@"favor");
}
- (IBAction)shareBtnPressed:(id)sender {
    [[AppSettings sharedSettings] popupShareMenu:self.share_data[@"share_title"] introduce:self.share_data[@"share_intro"] url:self.share_data[@"share_url"]];
}

@end
