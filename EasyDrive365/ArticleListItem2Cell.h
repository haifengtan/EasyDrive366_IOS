//
//  ArticleListItem2Cell.h
//  EasyDrive366
//
//  Created by Steven Fu on 1/15/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleListItem2Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIButton *favorbtn;
@property (weak, nonatomic) IBOutlet UIButton *sharebtn;

@property (nonatomic) id share_data;
@end
