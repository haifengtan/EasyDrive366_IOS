//
//  CommentListCell.h
//  EasyDrive366
//
//  Created by Steven Fu on 12/18/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;

@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;

@property (nonatomic) int rating;
@end
