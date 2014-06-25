//
//  BoundHeader.h
//  EasyDrive366
//
//  Created by Steven Fu on 12/19/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVUIGradientButton.h"

@interface BoundHeader : UIView
@property (weak, nonatomic) IBOutlet NVUIGradientButton *btnOK;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak,nonatomic) UINavigationController *parent;

@end
