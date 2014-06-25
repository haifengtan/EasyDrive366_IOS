//
//  MaintanViewController.h
//  EasyDrive365
//
//  Created by Fu Steven on 3/2/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetViewController.h"
#import "EditTableViewController.h"

@interface EditMaintainDataSource:NSObject <EditDataDelegate>
@property (weak,nonatomic) id<EditDataSourceDelegate> delegate;
@property (nonatomic) id result;
-(id)initWithData:(id)data;
@end

@interface MaintanViewController :  NetViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
