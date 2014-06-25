//
//  FeedbackController2.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/5/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "FeedbackController2.h"
#import "AppSettings.h"
#import "FeedbackInputCell.h"
#import "FeedbackInfoCell.h"

@interface FeedbackController2 ()<FeedbackInputDelegate>{
    id _list;
}

@end

@implementation FeedbackController2

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

    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0?1:[_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    if (indexPath.section==0){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FeedbackInputCell" owner:nil options:nil] objectAtIndex:0];
        FeedbackInputCell *feedCell = (FeedbackInputCell *)cell;
        [feedCell setupPhone:self.phone];
        feedCell.delegate = self;
    }else{
        //cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell = [[NSBundle mainBundle] loadNibNamed:@"FeedbackInfoCell" owner:nil options:nil][0];
        FeedbackInfoCell *rcell = (FeedbackInfoCell *)cell;
        id item = [_list objectAtIndex:indexPath.row];
        rcell.lblUsername.text = item[@"user_name"];
        rcell.lblContent.text = item[@"content"];
        rcell.lblDate.text = item[@"update_time"];
    }
   
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==0?0:22.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section==0?250.0f:100.0f;
}
-(void)loadData{
    NSString *url;
    if (self.taskid>0) {
        url = [NSString stringWithFormat:@"api/get_feedback_user?userid=%d&taskid=%d",[AppSettings sharedSettings].userid,self.taskid];
    }else{
        url = [NSString stringWithFormat:@"api/get_feedback_user?userid=%d",[AppSettings sharedSettings].userid];
    }
    [[[AppSettings sharedSettings] http] get:url block:^(id json) {
        id temp = json[@"result"][@"data"];
        
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sort" ascending:YES];
        _list =[temp sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        [self.tableView reloadData];
    }];
}
-(void)feedback:(NSString *)info phone:(NSString *)phone{
    if (info.length>0 && info.length<=200){
        NSString *url = [NSString stringWithFormat:@"api/add_feeback?userid=%d&communication=%@&content=%@",[AppSettings sharedSettings].userid,phone,info];
        [[HttpClient sharedHttp] get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                [[[UIAlertView alloc] initWithTitle:AppTitle message:@"反馈已经提交，请耐心等候。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
                [self loadData];
                
            }
            
        }];
    }else{
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"请输入反馈信息，字数小于200." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    }
}

@end
