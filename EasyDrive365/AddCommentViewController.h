//
//  AddCommentViewController.h
//  EasyDrive366
//
//  Created by Fu Steven on 6/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVUIGradientButton.h"

@interface AddCommentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *txtContent;
@property (weak, nonatomic) IBOutlet UILabel *lblLeft;
@property (weak, nonatomic) IBOutlet NVUIGradientButton *buttonAdd;

@property (nonatomic) id article;
@end
