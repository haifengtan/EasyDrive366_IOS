//
//  FeedbackInputCell.h
//  EasyDrive366
//
//  Created by Steven Fu on 12/5/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVUIGradientButton.h"

@protocol FeedbackInputDelegate <NSObject>

-(void)feedback:(NSString *)info phone:(NSString *)phone;

@end

@interface FeedbackInputCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *txtContent;
@property (weak, nonatomic) IBOutlet UILabel *lblLeft;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet NVUIGradientButton *btnOK;

@property (nonatomic) id<FeedbackInputDelegate> delegate;

-(void)setupPhone:(NSString *)phone;
@end
