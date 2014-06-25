//
//  ExecuteTaskController.h
//  EasyDrive366
//
//  Created by Steven Fu on 12/20/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVUIGradientButton.h"
@interface ExecuteTaskController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblRemark;

@property (weak, nonatomic) IBOutlet NVUIGradientButton *button;


@property (nonatomic) int task_id;
@end
