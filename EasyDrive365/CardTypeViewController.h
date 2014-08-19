//
//  CardTypeViewController.h
//  EasyDrive366
//
//  Created by admin on 14-8-19.
//  Copyright (c) 2014年 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickupData.h"

@interface CardTypeViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *cardTypePicker;
@property (nonatomic,copy) NSString *keyname;
@property (nonatomic,weak) id<PickupData> delegate;
@end
