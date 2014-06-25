//
//  CommentCell.h
//  EasyDrive366
//
//  Created by Fu Steven on 6/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *lblContent;

@property (weak, nonatomic) IBOutlet UILabel *lblUser;
@end
