//
//  ArticleListItemCell.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/12/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ArticleListItemCell.h"
#import "AMRatingControl.h"
#import "AppSettings.h"
#import "ItemCommentsController.h"
@interface ArticleListItemCell(){
    AMRatingControl *_ratingControl;
}

@end

@implementation ArticleListItemCell

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

-(void)setRating:(int)rating{
    if (!_ratingControl){
        _ratingControl =[[AMRatingControl alloc] initWithLocation:CGPointMake(185, 88) andMaxRating:5];
        [_ratingControl setRating:rating];
        [self addSubview:_ratingControl];
        //[_ratingControl setEnabled:YES];
        _ratingControl.handleTouch = NO;
        //[_ratingControl addTarget:self action:@selector(clickRate) forControlEvents:UIControlEventTouchUpInside];
        //[_ratingControl setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRate)];
        tap.cancelsTouchesInView = NO;
        [_ratingControl addGestureRecognizer:tap];
    }
}
-(void)clickRate{
    ItemCommentsController *vc =[[ItemCommentsController alloc] initWithStyle:UITableViewStylePlain];
    vc.itemId = self.share_data[@"id"];
    vc.itemType =@"article";
    [self.parent pushViewController:vc animated:YES];
}
- (IBAction)favorBtnPressed:(id)sender {
    NSLog(@"favor");
    if ([self.share_data[@"is_favor"] intValue]==0){
        NSString *url = [NSString stringWithFormat:@"favor/add?userid=%d&id=%@&type=ATL",[AppSettings sharedSettings].userid,self.share_data[@"id"]];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                [self.favorbtn setImage:[UIImage imageNamed:@"favor"] forState:UIControlStateNormal];
                [self setNeedsLayout];
                self.share_data[@"is_favor"]=@"1";
            }
        }];
    }else{
        NSString *url = [NSString stringWithFormat:@"favor/remove?userid=%d&id=%@&type=ATL",[AppSettings sharedSettings].userid,self.share_data[@"id"]];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                [self.favorbtn setImage:[UIImage imageNamed:@"favorno"] forState:UIControlStateNormal];
                [self setNeedsLayout];
                self.share_data[@"is_favor"]=@"0";
            }
        }];
    }
    
    
    
}
- (IBAction)shareBtnPressed:(id)sender {
    [[AppSettings sharedSettings] popupShareMenu:self.share_data[@"share_title"] introduce:self.share_data[@"share_intro"] url:self.share_data[@"share_url"]];
}
- (IBAction)emptyButtonPressed:(id)sender {
    //[self clickRate];
}
@end
