//
//  DoCommentController.h
//  EasyDrive366
//
//  Created by Steven Fu on 12/18/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVUIGradientButton.h"

@interface DoCommentController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *txtComment;
@property (weak, nonatomic) IBOutlet UILabel *lblLeft;

@property (weak, nonatomic) IBOutlet NVUIGradientButton *btnOK;

@property (nonatomic) NSString *item_id;
@property (nonatomic) NSString *item_type;
@end
