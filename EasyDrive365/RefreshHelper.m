//
//  RefreshHelper.m
//  EasyDrive366
//
//  Created by Fu Steven on 3/17/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "RefreshHelper.h"

@implementation RefreshHelper
-(id)initWithDelegate:(id<RefreshHelperDelegate>)delegate{
    self =[super init];
    if (self){
        self.delegate = delegate;
    }
    return self;
}
-(void)setupTableView:(UITableView *)tableView parentView:(UIView *)parentView{
    if (_refreshHeaderView==nil){
        EGORefreshTableHeaderView *view =[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f-tableView.bounds.size.height, parentView.frame.size.width, tableView.bounds.size.height)];
        view.delegate = self;
        [tableView addSubview:view];
        _refreshHeaderView = view;

        
    }
    [_refreshHeaderView refreshLastUpdatedDate];
}
-(void)endRefresh:(UITableView *)tableView{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tableView];
}

#pragma mark EGORefreshTableHeaderViewDelegate
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    [self.delegate loadData:1];
}
-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
    return _reloading;
}
-(NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view{
    return [NSDate date];
}
@end
