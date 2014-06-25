//
//  JobDetailController.h
//  EasyDrive366
//
//  Created by Steven Fu on 3/21/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobDetailController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel;
@property (weak, nonatomic) IBOutlet UITextView *txtContent;
@property (nonatomic) int job_id;

@end
