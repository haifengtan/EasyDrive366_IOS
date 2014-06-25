//
//  DatePickerViewController.h
//  EasyDrive365
//
//  Created by Fu Steven on 2/18/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickupData.h"
@interface DatePickerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic,copy) NSString *keyname;
@property (nonatomic,weak) id<PickupData> delegate;
@property (nonatomic,strong) NSString *value;
@end
