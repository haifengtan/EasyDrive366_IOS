//
//  InsuranceStep5Controller.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/27/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "InsuranceStep5Controller.h"
#import "AppSettings.h"
#import "InsuranceStep6Controller.h"

@interface InsuranceStep5Controller (){
    id _list;
    id _sectionList;
    BOOL _includingCom;
    BOOL _includingBiz;
}

@end

@implementation InsuranceStep5Controller

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

    self.title = @"第五步";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonSystemItemAction target:self action:@selector(backTo)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonSystemItemAction target:self action:@selector(confirm)];

    [self load_data];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)confirm{
    
    
    NSString *url = [NSString stringWithFormat:@"ins/carins_check?userid=%d&is_comm=%@&is_biz=%@",[AppSettings sharedSettings].userid,self.insurance_data[@"com"][@"is_com"],self.insurance_data[@"biz"][@"is_biz"]];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            NSLog(@"%@",json);
            InsuranceStep6Controller *vc = [[InsuranceStep6Controller alloc] initWithStyle:UITableViewStyleGrouped];
            vc.order_data = json[@"result"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}
-(void)load_data{
    _includingCom = [self.insurance_data[@"com"][@"is_com"] intValue]==1;
    _includingBiz = [self.insurance_data[@"biz"][@"is_biz"] intValue]==1;
    _sectionList =[[NSMutableArray alloc] initWithArray:@[self.insurance_data[@"biz"][@"title"],self.insurance_data[@"com"][@"title"],self.insurance_data[@"price_content"]]];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0){
        return [self.insurance_data[@"biz"][@"list"] count]+1;
    }else if (section==1){
        return 4;
    }else {
        return 1;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_sectionList objectAtIndex:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    if (indexPath.section==0){
        //biz
        if (indexPath.row==0){
            cell.textLabel.text = @"投保商业险";
            CGRect rect;
            if ([[AppSettings sharedSettings] isIos7]){
                rect = CGRectMake(250, 10, 50, 24);
            }else{
                rect = CGRectMake(220, 10, 50, 24);
            }
            UISwitch *sw = [[UISwitch alloc] initWithFrame:rect];
            sw.on = [self.insurance_data[@"biz"][@"is_biz"] intValue]==1;
            [cell.contentView addSubview:sw];
            [sw addTarget:self action:@selector(selectBiz:) forControlEvents:UIControlEventValueChanged];
        }else{
            int width;
            int additional ;
            if ([[AppSettings sharedSettings] isIos7]){
                width = 75;
                additional = 0;
            }else{
                width = 67;
                additional =10;
            }
            id item =[self.insurance_data[@"biz"][@"list"] objectAtIndex:indexPath.row-1];
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
        }
        
        
        
    }else if (indexPath.section==1){
        //com
        if (indexPath.row==0){
            cell.textLabel.text = @"选择交强险和车船税";
            CGRect rect;
            if ([[AppSettings sharedSettings] isIos7]){
                rect = CGRectMake(250, 10, 50, 24);
            }else{
                rect = CGRectMake(220, 10, 50, 24);
            }
            UISwitch *sw = [[UISwitch alloc] initWithFrame:rect];
            sw.on = [self.insurance_data[@"com"][@"is_com"] intValue]==1;
            [cell.contentView addSubview:sw];
            [sw addTarget:self action:@selector(selectCom:) forControlEvents:UIControlEventValueChanged];
        }else if (indexPath.row==1){
            cell.textLabel.text=@"交强险";
            cell.detailTextLabel.text = self.insurance_data[@"com"][@"com"];
        }else if (indexPath.row==2){
            cell.textLabel.text=@"车船税";
            cell.detailTextLabel.text = self.insurance_data[@"com"][@"tax"];
        }else if (indexPath.row==3){
            cell.textLabel.text=@"小计";
            cell.detailTextLabel.text = self.insurance_data[@"com"][@"com_total"];
        }
        
    }else{
        //summary
        cell.textLabel.text=self.insurance_data[_includingCom? @"total":@"total_nocomm"];
        if (!_includingBiz && _includingCom){
            cell.textLabel.text=self.insurance_data[@"total_only_comm"];
        }
        
    }
    return cell;
}

-(void)selectCom:(UISwitch *)sender{
    self.insurance_data[@"com"][@"is_com"]= [sender isOn]?@"1":@"0";
    _includingCom = [sender isOn];
    _sectionList =[[NSMutableArray alloc] initWithArray:@[self.insurance_data[@"biz"][@"title"],self.insurance_data[@"com"][@"title"],self.insurance_data[_includingCom?@"price_content":@"price_content_nocomm"]]];
    [self.tableView reloadData];
}
-(void)selectBiz:(UISwitch *)sender{
    self.insurance_data[@"biz"][@"is_biz"] = sender.isOn?@"1":@"0";
    _includingBiz = [sender isOn];
    _sectionList =[[NSMutableArray alloc] initWithArray:@[self.insurance_data[@"biz"][@"title"],self.insurance_data[@"com"][@"title"],self.insurance_data[_includingBiz?@"price_content":@"price_content_only_comm"]]];
    [self.tableView reloadData];
}
@end
