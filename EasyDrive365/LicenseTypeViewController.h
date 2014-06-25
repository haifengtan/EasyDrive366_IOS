//
//  LicenseTypeViewController.h
//  EasyDrive365
//
//  Created by Fu Steven on 2/17/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetTableViewController.h"
#import "PickupData.h"

@interface LicenseTypeViewController : NetTableViewController

@property (nonatomic,weak) id<PickupData> delegate;
@property (nonatomic,strong) NSString *value;
@end
