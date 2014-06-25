//
//  CompulsoryInsuranceViewController.h
//  EasyDrive365
//
//  Created by Fu Steven on 2/14/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVUIGradientButton.h"

@interface CompulsoryInsuranceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSString *_company;
    NSString *_phone;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet NVUIGradientButton *phoneButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
