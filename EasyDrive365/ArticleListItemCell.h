//
//  ArticleListItemCell.h
//  EasyDrive366
//
//  Created by Steven Fu on 12/12/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleListItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblVoternum;
@property (weak, nonatomic) IBOutlet UIButton *favorbtn;
@property (weak, nonatomic) IBOutlet UIButton *sharebtn;

@property (nonatomic) id share_data;
@property (nonatomic) int rating;
@property (nonatomic,weak) UINavigationController *parent;
@end
