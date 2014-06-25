//
//  FeedbackViewController.h
//  EasyDrive366
//
//  Created by Fu Steven on 5/20/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVUIGradientButton.h"

@interface FeedbackViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *txtfeedback;

@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (weak, nonatomic) IBOutlet UITextField *txtCommunication;
@property (weak, nonatomic) IBOutlet NVUIGradientButton *btnOK;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
