//
//  RefreshHelper.h
//  EasyDrive366
//
//  Created by Fu Steven on 3/17/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGORefreshTableHeaderView.h"
@protocol RefreshHelperDelegate<NSObject>
-(void)loadData:(int)reload;
@end;

@interface RefreshHelper : NSObject<UIScrollViewDelegate,EGORefreshTableHeaderDelegate>{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}
@property (nonatomic ) id<RefreshHelperDelegate> delegate;
@property (nonatomic) EGORefreshTableHeaderView *refreshHeaderView;

-(id)initWithDelegate:(id<RefreshHelperDelegate>)delegate;
-(void)setupTableView:(UITableView *)tableView parentView:(UIView *)parentView;
-(void)endRefresh:(UITableView *)tableView;

@end
