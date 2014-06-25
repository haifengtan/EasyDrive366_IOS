//
//  MyFavorController.m
//  EasyDrive366
//
//  Created by Steven Fu on 2/7/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "MyFavorController.h"
#import "AppSettings.h"
#import "FavorItemCell.h"
#import "UIImageView+AFNetworking.h"
#import "Browser2Controller.h"
#import "GoodsDetailController.h"
#import "ProviderDetailController.h"
#import "RefreshHelper.h"

@interface MyFavorController ()<RefreshHelperDelegate,UIScrollViewDelegate>{
    id _list;
    RefreshHelper *_helper;
}

@end

@implementation MyFavorController

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
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
#endif
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.title = @"我的收藏";
    _helper = [[RefreshHelper alloc] init];
    [_helper setupTableView:self.tableView parentView:self.view];
    _helper.delegate = self;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全部删除" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteAll)];
    [self loadData:0];

}

-(void)deleteAll{
    //nothing;
}
-(void)loadData:(int)reload{
    NSString *url;
    if (self.taskid>0){
        url = [NSString stringWithFormat:@"favor/find?userid=%d&type=&taskid=%d",[AppSettings sharedSettings].userid,self.taskid];
    }else{
        url = [NSString stringWithFormat:@"favor/find?userid=%d&type=",[AppSettings sharedSettings].userid];
    }
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if([[AppSettings sharedSettings] isSuccess:json]){
            _list = json[@"result"];
            [self.tableView reloadData];
            [_helper endRefresh:self.tableView];
        }
    }];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_helper.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_helper.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    id item = [_list objectAtIndex:indexPath.row];
    if (cell == nil){
        cell= [[[NSBundle mainBundle] loadNibNamed:@"FavorItemCell" owner:nil options:nil] objectAtIndex:0];
        FavorItemCell *aCell =(FavorItemCell *)cell;
        aCell.lblTitle.text =[NSString stringWithFormat:@"[%@]%@",item[@"type_name"],item[@"title"]];
        aCell.lblDescription.text =item[@"description"];
        aCell.lblPrice.text = item[@"price"];
        [aCell.imagePic setImageWithURL:[NSURL URLWithString:item[@"pic_url"]]];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = [_list objectAtIndex:indexPath.row];
    NSLog(@"%@",item);
    if ([item[@"type_id"] isEqualToString:@"ATL"]){
        NSString *url = item[@"url"];
        
        /*
         BrowserViewController *vc = [[BrowserViewController alloc] initWithNibName:@"BrowserViewController" bundle:nil];
         vc.title = item[@"title"];
         //        vc.url  = url;
         [self.navigationController pushViewController:vc animated:NO];
         [vc go:url];
         */
        Browser2Controller *vc = [[Browser2Controller alloc] initWithNibName:@"Browser2Controller" bundle:nil];
        vc.url = url;
        vc.title = item[@"title"];
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([item[@"type_id"] isEqualToString:@"GDS"]){
        GoodsDetailController *vc =[[GoodsDetailController alloc] initWithStyle:UITableViewStylePlain];
        vc.target_id =[item[@"content_id"] intValue];
        vc.title = item[@"name"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([item[@"type_id"] isEqualToString:@"SPV"]){
        ProviderDetailController *vc = [[ProviderDetailController alloc] initWithStyle:UITableViewStylePlain];
        vc.code= item[@"content_id"];
        
        vc.name = item[@"name"];
        [self.navigationController pushViewController:vc animated:YES];

    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete){
        id item = [_list objectAtIndex:indexPath.row];
        NSString *url = [NSString stringWithFormat:@"favor/del?userid=%d&id=%@",[AppSettings sharedSettings].userid,item[@"id"]];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                [_list removeObject:item];
                [self.tableView reloadData];
            }
        }];
    }
}
@end
