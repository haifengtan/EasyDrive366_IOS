//
//  FriendHeader.h
//  EasyDrive366
//
//  Created by Steven Fu on 12/20/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVUIGradientButton.h"

@interface FriendHeader : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblInvite_code;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet NVUIGradientButton *btnButton1;
@property (weak, nonatomic) IBOutlet NVUIGradientButton *btnButton2;

@property (weak, nonatomic) IBOutlet NVUIGradientButton *btnButton3;

@property (nonatomic,weak) UINavigationController *parent;
@property (weak, nonatomic) IBOutlet UITextField *txtInviteCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@end
