//
//  ButtonViewController.h
//  EasyDrive366
//
//  Created by Fu Steven on 4/26/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVUIGradientButton.h"
@protocol ButtonViewControllerDelegate
-(void)buttonPressed:(NVUIGradientButton *)button;
@end

@interface ButtonViewController : UIViewController
@property (weak, nonatomic) IBOutlet NVUIGradientButton *button;
@property (nonatomic) id<ButtonViewControllerDelegate> delegate;
@property (nonatomic) NSString *buttonText;
@property (nonatomic) int buttonType;
@end
