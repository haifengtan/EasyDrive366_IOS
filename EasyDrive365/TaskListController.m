//
//  TaskListController.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/19/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "TaskListController.h"
#import "AppSettings.h"
#import "TaskListCell.h"
#import "UIImageView+AFNetworking.h"
#import "TaskDispatch.h"

@interface TaskListController (){
    id _list;
}

@end

@implementation TaskListController

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
    self.title = @"我的任务";
    [self load_data];
}
-(void)load_data{
    NSString *url;
    if (self.taskid>0)
        url = [NSString stringWithFormat:@"bound/get_task_list?userid=%d&taskid=%d",[AppSettings sharedSettings].userid,self.taskid];
    else
        url = [NSString stringWithFormat:@"bound/get_task_list?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _list = json[@"result"][@"data"];
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
    if (cell==nil){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"TaskListCell" owner:nil options:nil] objectAtIndex:0];
    }
    id item = [_list objectAtIndex:indexPath.row];
    TaskListCell *aCell = (TaskListCell *)cell;
    [aCell.image setImageWithURL:[NSURL URLWithString:item[@"pic_url"]]];
    aCell.lblRemark.text = item[@"remark"];
    aCell.lblTitle.text = item[@"title"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = [_list objectAtIndex:indexPath.row];
    /*
    ExecuteTaskController *vc = [[ExecuteTaskController alloc] initWithNibName:@"ExecuteTaskController" bundle:nil];
    vc.task_id = [item[@"id"] intValue];
    [self.navigationController pushViewController:vc animated:YES];
     */
    TaskDispatch *dispatch =[[TaskDispatch alloc] initWithController:self.navigationController task:item];
    [dispatch pushToController];
}
@end
