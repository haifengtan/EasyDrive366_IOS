//
//  MyHistroyController.m
//  EasyDrive366
//
//  Created by Steven Fu on 2/7/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "MyHistroyController.h"
#import "AppSettings.h"
#import "FavorItemCell.h"
#import "UIImageView+AFNetworking.h"
#import "Browser2Controller.h"
#import "GoodsDetailController.h"
#import "ProviderDetailController.h"

@interface MyHistroyController ()<UIAlertViewDelegate>{
    id _list;
}

@end

@implementation MyHistroyController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.title = @"浏览历史";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全部删除" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteAll)];
    [self load_data];
}
-(void)deleteAll{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认" message:@"是否删除全部浏览历史？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"全部删除", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d",buttonIndex);
    if (buttonIndex==1){
        NSString *url = [NSString stringWithFormat:@"history/del_all?userid=%d",[AppSettings sharedSettings].userid];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if([[AppSettings sharedSettings] isSuccess:json]){
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

-(void)load_data{
    NSString *url;
    if (self.taskid>0)
        url = [NSString stringWithFormat:@"history/find?userid=%d&type=&taskid=%d",[AppSettings sharedSettings].userid,self.taskid];
    else
        url = [NSString stringWithFormat:@"history/find?userid=%d&type=",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if([[AppSettings sharedSettings] isSuccess:json]){
            _list = json[@"result"];
            [self.tableView reloadData];
        }
    }];
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
        aCell.lblOccur_time.text = item[@"occur_time"];
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
        NSString *url = [NSString stringWithFormat:@"history/del?userid=%d&id=%@",[AppSettings sharedSettings].userid,item[@"id"]];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                [_list removeObject:item];
                [self.tableView reloadData];
            }
        }];
    }
}

@end
