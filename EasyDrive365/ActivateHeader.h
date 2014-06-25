//
//  ActivateHeader.h
//  EasyDrive366
//
//  Created by Fu Steven on 8/29/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVUIGradientButton.h"

@protocol ActivateHeaderDelegate <NSObject>

-(void)buttonPressed:(NSString *)code;


@end

@interface ActivateHeader : UIView
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet NVUIGradientButton *btnOK;
@property (nonatomic,weak) id<ActivateHeaderDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextView *txt_remark;
@end
