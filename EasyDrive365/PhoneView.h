//
//  PhoneView.h
//  EasyDrive366
//
//  Created by Fu Steven on 3/16/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVUIGradientButton.h"

@interface PhoneView : UIView<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet NVUIGradientButton *phoneButton;
@property (strong,nonatomic) NSString *text;
@property (strong,nonatomic) NSString *phone;

-(void)initWithPhone:(NSString *)text phone:(NSString *)phone;

@end
