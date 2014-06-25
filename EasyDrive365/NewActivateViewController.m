//
//  NewActivateViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 8/29/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "NewActivateViewController.h"
#import "AppSettings.h"
#import "NVUIGradientButton.h"
#import "ActivateHeader.h"

@interface NewActivateViewController ()<ActivateHeaderDelegate,UIAlertViewDelegate>{
    id _list;
    ActivateHeader *_headerView;
    NSString *_code;
}

@end

@implementation NewActivateViewController

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
    self.title =@"我的卡券";

    [self loadData];
    if (self.isWizad){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonSystemItemAction target:self action:@selector(gotoBack)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonSystemItemAction target:self action:@selector(gotoSettings)];
    }
}
-(void)gotoBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)gotoSettings{
    [self.navigationController popToRootViewControllerAnimated:YES];
     //[self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1]  animated:YES];
     
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [_list count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_list objectAtIndex:section] count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    id item = [[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = item[@"title"];
    cell.detailTextLabel.text=item[@"detail"];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0){
        return 200;
    }else{
        return 22.0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0){
        if (!_headerView){
            [self createHeaderView];
        }
        _headerView.txt_remark.text = self.remark;
        return _headerView;
    }else{
        return nil;
    }
}
-(void)createHeaderView{
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"ActivateHeader" owner:nil options:nil] objectAtIndex:0];
    _headerView.delegate = self;
    _headerView.btnOK.text = @"激活服务卡";

    //_headerView.btnOK.style = NVUIGradientButtonStyleBlackOpaque;
    _headerView.backgroundColor = [UIColor clearColor];
    /*
    _headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 280, 21)];
    label.backgroundColor =[UIColor clearColor];
    label.text = @"this is a label";
    [_headerView addSubview:label];
    UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(20, 41, 280, 30)];
    text.placeholder =@"code";
    text.borderStyle = UITextBorderStyleLine;
    [_headerView addSubview:text];
    NVUIGradientButton *button =[[NVUIGradientButton alloc] initWithFrame:CGRectMake(20, 81, 280, 37)];
    button.text = @"pressme";
    
    [button addTarget:self action:@selector(buttonPress) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:button];
     */
}
-(void)buttonPressed:(NSString *)code{
    NSLog(@"button press:%@",code);
    if (![code isEqualToString:@""]){
        _code = code;
        [[[UIAlertView alloc] initWithTitle:AppTitle message:[NSString stringWithFormat:@"确定要激活【%@】",code] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"激活" , nil] show ];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1){
        NSString *url = [NSString stringWithFormat:@"api/add_activate_code_list?userid=%d&code=%@",[AppSettings sharedSettings].userid,_code];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                [self processData:json[@"result"]];
            }
        }];
    }
}
-(void)loadData{
    //_list =@[@[@{@"title":@"a",@"detail":@"b"}],@[@{@"title":@"a",@"detail":@"b"}]];
    
    NSString *url;
    if (self.taskid>0)
        url = [NSString stringWithFormat:@"api/get_activate_code_list?userid=%d&taskid=%d",[AppSettings sharedSettings].userid,self.taskid];
    else
        url = [NSString stringWithFormat:@"api/get_activate_code_list?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            [self processData:json[@"result"]];
        }
    }];
    
}
-(void)processData:(id)list{
    NSLog(@"%@",list);
    if (_list){
        [_list removeAllObjects];
    }else{
        _list=[[NSMutableArray alloc] init];
    }
    for (id item in list) {
        id list1=@[@{@"title":@"卡号",@"detail":item[@"number"]},
                   @{@"title":@"激活码",@"detail":item[@"code"]},
                   @{@"title":@"激活日期",@"detail":item[@"activate_date"]},
                   @{@"title":@"有效期至",@"detail":item[@"valid_date"]},
                   @{@"title":@"服务项目:",@"detail":@""}];

        NSMutableArray *list2 =[[NSMutableArray alloc] initWithArray:list1 copyItems:YES];
        for (id item2  in item[@"contents"]) {
            [list2 addObject:@{@"title":item2[@"name"],@"detail":[NSString stringWithFormat:@"%@次",item2[@"count"]]}];
        }
        [_list addObject:list2];
    }
    [self.tableView reloadData];
    /*
     user_id: "128",
     number: "TEST0000001",
     code: "hvx6ldbp",
     status: "15",
     checkin_time: "2013-08-29",
     checkout_status: "0",
     price: "100",
     valid_months: "12",
     card_type: "TEST-A",
     activate_date: "2013-08-13",
     valid_date: "2014-08-13",
     is_valid: "1",
     expiring_date: "2013-08-29",
     contents: [
     {
     code: "0202",
     name: "更换备胎",
     count: "5"
     },
     {
     code: "0203",
     name: "送油送水",
     count: "2"
     }
     ]
     },
     */
}
@end
