//
//  InsuranceListController.m
//  EasyDrive366
//
//  Created by Steven Fu on 2/24/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "InsuranceListController.h"
#import "AppSettings.h"
#import "InsuranceStep2Controller.h"
#import "InsuranceListCell.h"
@interface InsuranceListController (){
    id _list;
}

@end

@implementation InsuranceListController

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
    self.title = @"投保单";
    [self load_data];
}
-(void)load_data{
    NSString *url = [NSString stringWithFormat:@"ins/list_quote?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
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
    if (cell==nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InsuranceListCell" owner:nil options:nil] objectAtIndex:0];
    }
    id item = [_list objectAtIndex:indexPath.row];
    //car_id  price_time  status_name
    InsuranceListCell *aCell = (InsuranceListCell *)cell;
    aCell.lblTitle.text = item[@"car_id"];
    aCell.lblTime.text = item[@"price_time"];
    aCell.lblStatus.text = item[@"status_name"];
    /*
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 24)];
    label.font=[UIFont fontWithName:@"Arial" size:12];
    label.backgroundColor = [UIColor clearColor];
    
    label.text = item[@"car_id"];
    [cell addSubview:label];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 120, 24)];
    label2.text = item[@"price_time"];
    label2.font=[UIFont fontWithName:@"Arial" size:12];
    label2.backgroundColor = [UIColor clearColor];
    
    [cell addSubview:label2];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(230, 10, 100, 24)];
    label3.text = item[@"status_name"];
    label3.font=[UIFont fontWithName:@"Arial" size:12];
    label3.backgroundColor = [UIColor clearColor];
    
    [cell addSubview:label3];
     */
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = [_list objectAtIndex:indexPath.row];
    InsuranceStep2Controller *vc = [[InsuranceStep2Controller alloc] initWithStyle:UITableViewStyleGrouped];
    vc.ins_id = item[@"id"];
    [self.navigationController pushViewController:vc animated:YES];
 }
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete){
        id item = [_list objectAtIndex:indexPath.row];
        NSString *url = [NSString stringWithFormat:@"ins/del_quote?userid=%d&id=%@",[AppSettings sharedSettings].userid,item[@"id"]];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                [_list removeObject:item];
                [self.tableView reloadData];
            }
        }];
    }
}
@end
