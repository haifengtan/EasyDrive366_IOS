//
//  BusinessInsViewController.h
//  EasyDrive365
//
//  Created by Fu Steven on 2/25/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetViewController.h"
@interface BusinessInsViewController : NetViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
