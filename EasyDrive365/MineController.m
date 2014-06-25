//
//  MineController.m
//  EasyDrive366
//  我的页面
//  Created by Steven Fu on 6/1/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "MineController.h"
#import "Menu.h"
#import "NavigationCell.h"
#import "MenuItem.h"
#import "AppSettings.h"
#import "UserProfileView.h"

@interface MineController (){
    id _list;
    UserProfileView *_headerView;
    UIRefreshControl *_refreshControl;
}

@end

@implementation MineController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的";
    
    [[HttpClient sharedHttp] online];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(load_data) name:@"logout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(load_data) name:LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update_user_profile) name:UPDATE_USER_PROFILE object:nil];
    
    _refreshControl= [[UIRefreshControl alloc] init];
    self.refreshControl = _refreshControl;
    [_refreshControl addTarget:self action:@selector(load_data) forControlEvents:UIControlEventValueChanged];

    [self load_data];
}
-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}
-(void)update_user_profile{
    [_headerView load_data:0];
}
-(void)load_data{
    [[AppSettings sharedSettings] get_latest];
    [_headerView load_data:0];
    [_refreshControl endRefreshing];
}

//Table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[Menu sharedMenu].list count] ;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NavigationCell"  owner:self options:nil];
    NavigationCell *cell =[nib objectAtIndex:0];
    MenuItem *item = [[Menu sharedMenu].list objectAtIndex:indexPath.row];
    ((NavigationCell *)cell).titleLabel.text = item.title;
    ((NavigationCell *)cell).keyname = item.name;
    if (item.imagePath && ![item.imagePath isEqualToString:@""]){
        ((NavigationCell *)cell).imgeIcon.image = [UIImage imageNamed:item.imagePath];
    }
    cell.rootController = self.navigationController;
    return cell;

    
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>=[[Menu sharedMenu].list count]){
        return ;
    }
    MenuItem *item = [[Menu sharedMenu].list objectAtIndex:indexPath.row];
    NSLog(@"Select %@",item.title);
    [[Menu sharedMenu] pushToController:self.navigationController key:item.name title:item.title url:nil];
    
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0){
        if (!_headerView){
            _headerView =[[UserProfileView alloc] initWithController:self.navigationController taskid:0];
        }
        return _headerView;
    }else
        return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0){
        return 180;
    }else{
        return 11;
    }
}
@end
