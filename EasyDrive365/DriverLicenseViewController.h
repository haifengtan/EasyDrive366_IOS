//
//  DriverLicenseViewController.h
//  EasyDrive365
//
//  Created by Fu Steven on 2/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetViewController.h"
#import "EditTableViewController.h"

@interface EditDriverLicenseDataSource:NSObject<EditDataDelegate>
-(id)initWithData:(id)data;
@property (nonatomic,strong) id result;
@property (nonatomic,weak) id<EditDataSourceDelegate> delegate;
@end


@interface DriverLicenseViewController : NetViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
