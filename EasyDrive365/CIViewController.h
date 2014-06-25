//
//  CIViewController.h
//  EasyDrive366
//
//  Created by Fu Steven on 3/20/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetViewController.h"

@interface CIViewController : NetViewController<UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITabBar *tabbar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
