//
//  VendorViewController.h
//  EasyDrive366
//
//  Created by Fu Steven on 5/9/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetViewController.h"
#import "NVUIGradientButton.h"

@interface VendorViewController : NetViewController
@property (weak, nonatomic) IBOutlet UILabel *lblShopName;

@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UITextView *textDescription;

@property (weak, nonatomic) IBOutlet NVUIGradientButton *phoneButton;
@property (nonatomic) NSString *code;
@end
