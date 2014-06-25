//
//  IncomingViewController.h
//  EasyDrive366
//
//  Created by Fu Steven on 5/9/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetViewController.h"
@interface IncomingViewController : NetViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) NSString *code;
@property (nonatomic,retain) NSString *pageId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
