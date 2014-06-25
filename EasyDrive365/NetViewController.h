//
//  NetViewController.h
//  EasyDrive365
//
//  Created by Fu Steven on 2/14/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpClientDelegate.h"
#import "HttpHelper.h"
#import "EGORefreshTableHeaderView.h"

@interface NetViewController : UIViewController<HttpClientDelegate,UIScrollViewDelegate,EGORefreshTableHeaderDelegate,UIActionSheetDelegate>{
    HttpHelper *_helper;
    NSString *_phone;
    NSString *_company;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    BOOL _reloadDirectly;
   
}
@property (nonatomic) int taskid;

-(void)setup;
-(void)processData:(id)json;
-(void)setupTableView:(UITableView *)tableView;
-(void)endRefresh:(UITableView *)tableView;


@end
