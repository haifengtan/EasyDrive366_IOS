//
//  CarHelpTabController.m
//  EasyDrive366
//
//  Created by Fu Steven on 5/9/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "CarHelpTabController.h"
#import "VendorViewController.h"
#import "ServiceNoteViewController.h"
#import "IncomingViewController.h"
#import "ArticleController.h"
#import "Browser2Controller.h"

@interface CarHelpTabController (){
    UITabBarController *_tabController;
    VendorViewController *_venderController;
    ServiceNoteViewController *_noteController;
    IncomingViewController *_incomingController;
}

@end

@implementation CarHelpTabController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_venderController =[[VendorViewController alloc] initWithNibName:@"VendorViewController" bundle:nil];
    _venderController.code = self.code;
    _venderController.tabBarItem=[[UITabBarItem alloc] initWithTitle:@"服务商" image:[UIImage imageNamed:@"0087.png"] tag:1];
    _venderController.title = @"服务商";
    
    _noteController =[[ServiceNoteViewController alloc] initWithNibName:@"ServiceNoteViewController" bundle:nil];
    _noteController.code = self.code;
    _noteController.tabBarItem =[[UITabBarItem alloc] initWithTitle:@"服务明细" image:[UIImage imageNamed:@"0052.png"] tag:2];
    _noteController.title = @"服务明细";
    
    _incomingController =[[IncomingViewController alloc] initWithNibName:@"IncomingViewController" bundle:nil];
    _incomingController.tabBarItem =[[UITabBarItem alloc] initWithTitle:@"易驾百科" image:[UIImage imageNamed:@"0177.png"] tag:3];
    _incomingController.title = @"易驾百科";
    _incomingController.code = self.code;
    _incomingController.pageId = self.pageId;
    _tabController =[[UITabBarController alloc] init];
    _tabController.viewControllers=@[_venderController,_noteController,
        _incomingController];
    _tabController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_tabController.view];
    self.title = @"详细信息";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoArticle:) name:OPEN_ARTICLE object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)gotoArticle:(NSNotification *)notification{
    id item = notification.userInfo;
    
    ArticleController *vc =[[ArticleController alloc] initWithNibName:@"ArticleController" bundle:nil];
    vc.article = item;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    /*
    
    Browser2Controller *vc = [[Browser2Controller alloc] initWithNibName:@"Browser2Controller" bundle:nil];
    vc.article = item;
    [self.navigationController pushViewController:vc animated:YES];
    */

}

@end
