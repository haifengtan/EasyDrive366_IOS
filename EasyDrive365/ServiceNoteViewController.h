//
//  ServiceNoteViewController.h
//  EasyDrive366
//
//  Created by Fu Steven on 5/9/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetViewController.h"
#import "NVUIGradientButton.h"
@interface ServiceNoteViewController : NetViewController
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet NVUIGradientButton *btnPhone;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (nonatomic) NSString *code;
@end
