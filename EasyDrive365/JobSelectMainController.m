//
//  JobSelectMainController.m
//  EasyDrive366
//
//  Created by Steven Fu on 3/20/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "JobSelectMainController.h"
#import "AppSettings.h"
#import "JobItemCell.h"

@interface JobSelectMainController (){
    id _list;
    NSMutableArray *_dict;
    id _current;
}

@end

@implementation JobSelectMainController

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
    
    self.title = @"职业分类选择";
    [self init_data];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(finished)];
}
-(void)finished{
    if (self.job_id){
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:SELECTED_JOBITEM object:nil userInfo:_current];
        
    }else{
        [[[UIAlertView alloc] initWithTitle:nil message:@"请选择一个职业" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show ];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)init_data{
    NSString *url = [NSString stringWithFormat:@"order/list_career?userid=%d&orderid=%@",[AppSettings sharedSettings].userid,self.order_id];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _list = json[@"result"];
            _dict = [[NSMutableArray alloc] initWithCapacity:[_list count]];
            for (id item in _list) {
                NSString *name =item[@"trade_name"];

                [_dict addObject:[name substringToIndex:2]];
            }
            [self.tableView reloadData];
        }
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [_list count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [[_list objectAtIndex:section][@"list"] count];;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_list objectAtIndex:section][@"trade_name"];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier =@"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil){
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell =[[[NSBundle mainBundle] loadNibNamed:@"JobItemCell" owner:nil options:nil] objectAtIndex:0];
    }
    JobItemCell *jCell = (JobItemCell *)cell;
    id item = [[_list objectAtIndex:indexPath.section][@"list"] objectAtIndex:indexPath.row];
    jCell.lblTitle.text = item[@"name"];
    jCell.lblContent.text = item[@"content"];
    jCell.lblLevel.text = item[@"level"];
    jCell.job = item;
    jCell.parent = self.navigationController;
    if ([item[@"id"] intValue]==self.job_id){
        jCell.accessoryType = UITableViewCellAccessoryCheckmark;
        _current = item;
    }else{
        jCell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = [[_list objectAtIndex:indexPath.section][@"list"] objectAtIndex:indexPath.row];
    self.job_id =[item[@"id"] intValue];
    _current = item;
    [self.tableView reloadData];
}
/*
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _dict;
}// return list of section titles to display in section index view (e.g. "ABCD...Z#")
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index; {
    NSLog(@"%@",title);
    return index;
}
*/

@end
