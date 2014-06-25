//
//  InsuranceDetailController.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/27/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "InsuranceDetailController.h"
#import "AppSettings.h"
#import "InsuranceListController.h"
@interface InsuranceDetailController (){
    id _list;
}

@end

@implementation InsuranceDetailController

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

    self.title =@"我的保险";
    self.insurance_id = @"123";
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"投保单" style:UIBarButtonItemStyleBordered target:self action:@selector(openitems)];
    [self load_data];
}
-(void)openitems{
    InsuranceListController *vc = [[InsuranceListController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)load_data{
    NSString *url;
    if (self.taskid>0)
        url = [NSString stringWithFormat:@"ins/carins_get_one?userid=%d&id=%@&taskid=%d",[AppSettings sharedSettings].userid,self.insurance_id,self.taskid];
    else
        url = [NSString stringWithFormat:@"ins/carins_get_one?userid=%d&id=%@",[AppSettings sharedSettings].userid,self.insurance_id];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            id items0 = @[@{@"title":@"保单号",@"detail":json[@"result"][@"po"]},
                          @{@"title":@"保险期限",@"detail":json[@"result"][@"valid"]}];
            id items1 =@[@{@"title":@"姓名",@"detail":json[@"result"][@"insured_name"]},
                         @{@"title":@"身份证",@"detail":json[@"result"][@"insured_idcard"]},
                         @{@"title":@"手机号",@"detail":json[@"result"][@"insured_phone"]},
                         @{@"title":@"车牌号",@"detail":json[@"result"][@"car_id"]},
                         @{@"title":@"VIN",@"detail":json[@"result"][@"vin"]}];
            id items3 = @[@{@"title":@"交强险",@"detail":json[@"result"][@"com"]},
                          @{@"title":@"车船税",@"detail":json[@"result"][@"tax"]}];
            _list =@[items0,items1,json[@"result"][@"list"],items3];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_list objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    id item = [[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.section==2){
        /*
        UILabel *lblTitle =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 75, 24)];
        lblTitle.text = item[@"insu_name"];
        lblTitle.font=[UIFont fontWithName:@"Arial Bold" size:14];
        [cell.contentView addSubview:lblTitle];
        UILabel *lbl2 =[[UILabel alloc] initWithFrame:CGRectMake(85, 10, 75, 24)];
        lbl2.text = item[@"amount"];
        lbl2.font=[UIFont fontWithName:@"Arial" size:12];
        lbl2.textAlignment =NSTextAlignmentRight;
        [cell.contentView addSubview:lbl2];
        UILabel *lbl3 =[[UILabel alloc] initWithFrame:CGRectMake(160, 10, 75, 24)];
        lbl3.text = item[@"fee"];
        lbl3.font=[UIFont fontWithName:@"Arial" size:12];
        lbl3.textAlignment =NSTextAlignmentRight;
        [cell.contentView addSubview:lbl3];
        UILabel *lbl4 =[[UILabel alloc] initWithFrame:CGRectMake(235, 10, 75, 24)];
        lbl4.text = item[@"no_excuse"];
        lbl4.textAlignment =NSTextAlignmentRight;
        lbl4.font=[UIFont fontWithName:@"Arial" size:12];
        [cell.contentView addSubview:lbl4];
         */
        //biz
        int width;
        int additional ;
        if ([[AppSettings sharedSettings] isIos7]){
            width = 75;
            additional = 0;
        }else{
            width = 67;
            additional =10;
        }

        UILabel *lblTitle =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, width+additional, 24)];
        lblTitle.text = item[@"insu_name"];
        lblTitle.font=[UIFont fontWithName:@"Arial Bold" size:12];
        lblTitle.backgroundColor  = [UIColor clearColor];
        [cell.contentView addSubview:lblTitle];
        UILabel *lbl2 =[[UILabel alloc] initWithFrame:CGRectMake(10+additional+width, 10, width, 24)];
        lbl2.text = item[@"amount"];
        lbl2.font=[UIFont fontWithName:@"Arial" size:12];
        lbl2.backgroundColor = [UIColor clearColor];
        lbl2.textAlignment =NSTextAlignmentRight;
        [cell.contentView addSubview:lbl2];
        UILabel *lbl3 =[[UILabel alloc] initWithFrame:CGRectMake(10+additional+width*2, 10, width, 24)];
        lbl3.text = item[@"fee"];
        lbl3.font=[UIFont fontWithName:@"Arial" size:12];
        lbl3.backgroundColor = [UIColor clearColor];
        lbl3.textAlignment =NSTextAlignmentRight;
        [cell.contentView addSubview:lbl3];
        UILabel *lbl4 =[[UILabel alloc] initWithFrame:CGRectMake(10+additional+width*3, 10, width, 24)];
        lbl4.text = item[@"no_excuse"];
        lbl4.textAlignment =NSTextAlignmentRight;
        lbl4.font=[UIFont fontWithName:@"Arial" size:12];
        lbl4.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:lbl4];
    }else{
        cell.textLabel.text = item[@"title"];
        cell.detailTextLabel.text = item[@"detail"];
    }

    
    return cell;
}



@end
