//
//  ViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 1/29/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ViewController.h"
#import "HttpClient.h"
#import "AppSettings.h"
#import "NavigationCell.h"
#import "Menu.h"
#import "MenuItem.h"
#import "WelcomeViewController.h"
#import "SettingsViewController.h"
#import "ShowLocationViewController.h"
#import "GoodsListController.h"
#import "ProviderListController.h"
#import "ArticleListController.h"
#import "AppDelegate.h"
#import "SignupStep1ViewController.h"
#import "SignupStep0ViewController.h"
#import "DetailPictureCell.h"
#import "UIImageView+AFNetworking.h"
#import "AppSettings.h"
#import "Browser2Controller.h"
#import "TaskDispatch.h"

#define TAG_HOMEPAGE 0
#define TAG_MAP 1
#define TAG_GOODS 2
#define TAG_PROVIDER 3
#define TAG_ARTICLE 4


@interface ViewController ()<UIAlertViewDelegate>{
    NSMutableArray *_list;
    RefreshHelper *_helper;
    id _imageList;
    UIImageView *_imageView;
    UIPageControl *_pager;
    int _index;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
#endif
    self.title = AppTitle;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    _helper =[[RefreshHelper alloc] initWithDelegate:self];
    [_helper setupTableView:self.tableview parentView:self.view];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonSystemItemAction target:self action:@selector(settingsButtonPress:)];
    /*
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle =[[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableview addSubview:refreshControl];
    */
    
    
    
    [[HttpClient sharedHttp] online];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNews:) name:@"NavigationCell_01" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"logout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(need_set:) name:NEED_SET object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsButtonPress:) name:@"Login_First" object:nil];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goLeft)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableview addGestureRecognizer:swipeLeft];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goRight)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableview addGestureRecognizer:swipeRight];
    
    NSString *url = [NSString stringWithFormat:@"api/get_mainform?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _imageList = json[@"result"];
            [self.tableview reloadData];
            [[AppSettings sharedSettings] get_latest];
        }
    }];
    
    
    
}
-(void)showPicture:(int)i{
    NSString *url = [_imageList objectAtIndex:i][@"pic_url"];
    [_imageView setImageWithURL:[NSURL URLWithString:url]];
    _pager.currentPage = i;
}

-(void)goRight{
    _index--;
    if (_index<0){
        _index =[_imageList count]-1;
        
    }
    [self showPicture:_index];
}
-(void)goLeft{
    _index++;
    if (_index>[_imageList count]-1){
        _index=0;
    }
    [self showPicture:_index];
}
-(void)getNews:(NSNotification *)noti{
    [_helper endRefresh:self.tableview];
}
-(void)loadData:(int)reload{
    [self get_latest];
}
-(void)get_latest
{
    NSString *url = [NSString stringWithFormat:@"api/get_mainform?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _imageList = json[@"result"];
            [self.tableview reloadData];
    
        }
    }];
    [[AppSettings sharedSettings] get_latest];
    
}
-(void)handleRefresh:(UIRefreshControl *)sender{
    NSLog(@"i need to refresh! %@",[sender class]);
    [self get_latest];
    [sender endRefreshing];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    BOOL islogin = [AppSettings sharedSettings].isLogin;
    /*
    if (!islogin){
        WelcomeViewController *vc = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:NO];
        
    }else{
        if ([AppSettings sharedSettings].isNeedRefresh){
            [[AppSettings sharedSettings] get_latest];
        }
    }
     */
    if (!islogin){
        [AppSettings sharedSettings].userid=-1;
        self.navigationItem.rightBarButtonItem.title = @"登录";
        
    }else{
        self.navigationItem.rightBarButtonItem.title = @"设置";
    }
    if ([AppSettings sharedSettings].isNeedRefresh){
        [[AppSettings sharedSettings] get_latest];
    }
    
    
}

-(void)settingsButtonPress:(id)sender
{
    
    BOOL islogin = [AppSettings sharedSettings].isLogin;
    if (!islogin){
        WelcomeViewController *vc = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:NO];
        return;
    }
   
   /*
    SettingsViewController *vc = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
    */
    SignupStep0ViewController *vc = [[SignupStep0ViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];

}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0){
        [self logout];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
   
    [[NSNotificationCenter defaultCenter] removeObserver:self];
   
    [self setTableview:nil];
   
    [self setTabBar:nil];
    [super viewDidUnload];
}
-(void)loginSuccess{
    NSString *url = [NSString stringWithFormat:@"api/get_mainform?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _imageList = json[@"result"];
            [self.tableview reloadData];
            [[AppSettings sharedSettings] get_latest];
        }
    }];
}
- (IBAction)logout {
    [AppSettings sharedSettings].isLogin = FALSE;
    [AppSettings sharedSettings].userid = -1;
    [[AppSettings sharedSettings] save];
    /*
    WelcomeViewController *vc = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:NO];
     */
    NSString *url = [NSString stringWithFormat:@"api/get_mainform?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _imageList = json[@"result"];
            [self.tableview reloadData];
            [[AppSettings sharedSettings] get_latest];
        }
    }];
}


//Table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0){
        return 1;
    }else{
        return [[Menu sharedMenu].list count] ;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0){
        UITableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailPictureCell" owner:nil options:nil] objectAtIndex:0];
        DetailPictureCell *aCell = (DetailPictureCell *)cell;
        if (_imageList && [_imageList count]>0){
            [aCell.image setImageWithURL:[NSURL URLWithString:[_imageList objectAtIndex:0 ][@"pic_url"]]];
            aCell.pager.numberOfPages =[ _imageList count];
        }else{
            [aCell.image setImage:[UIImage imageNamed:@"default_640x234"]];
            aCell.pager.numberOfPages =[ _imageList count];
        }
        
        _imageView = aCell.image;
        _pager = aCell.pager;
        return cell;
    }else{
        if (indexPath.row>=[[Menu sharedMenu].list count]){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            return cell;
        }else{
            
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

        
    }
    
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section==0){
        return 150.0f;
        
    }
    return 50.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0){
        id item = [_imageList objectAtIndex:_pager.currentPage];
        NSLog(@"%@",item);
        id obj = @{@"id":item[@"id"],@"page_id":item[@"page_id"],@"action_url":item[@"url"]};
        TaskDispatch *dispatch =[[TaskDispatch alloc] initWithController:self.navigationController task:obj];
        [dispatch pushToController];
        
    }else{
        if (indexPath.row>=[[Menu sharedMenu].list count]){
            return ;
        }
        MenuItem *item = [[Menu sharedMenu].list objectAtIndex:indexPath.row];
        NSLog(@"Select %@",item.title);
        [[Menu sharedMenu] pushToController:self.navigationController key:item.name title:item.title url:nil];

    }
   

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_helper.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_helper.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

-(void)need_set:(NSNotification *)notification{
    NSString *message = [notification object];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:AppTitle message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1){
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).tabbarController.selectedIndex =0;
        SignupStep1ViewController *vc = [[SignupStep1ViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.commingFrom = @"主页";
        [self.navigationController pushViewController:vc animated:YES];

    }
}
@end
