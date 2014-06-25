//
//  DriverLicenseViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "DriverLicenseViewController.h"
#import "PhoneView.h"
#import "DisplayTextCell.h"

@implementation EditDriverLicenseDataSource

-(id)initWithData:(id)data{
    self = [super init];
    if (self){
        _result = data;
    }
    return self;
}
-(int)textFieldCount{
    return 2;
}
-(NSArray *)getSections{
    return @[@"基本信息"];
}
-(NSArray *)getItems{
    return @[@[ @{@"name":@"证件号码",@"key":@"license_id",@"mode":@"",@"description":@"",@"vcname":@""},
    @{@"name":@"姓名",@"key":@"name",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"准驾车型",@"key":@"car_type",@"mode":@"add",@"description":@"",@"vcname":@"LicenseTypeViewController"},
    @{@"name":@"初领日期",@"key":@"init_date",@"mode":@"add",@"description":@"",@"vcname":@"DatePickerViewController"}]];
}
-(NSDictionary *)getInitData{
    if (!_result){
        _result = [[NSMutableDictionary alloc] init];
        [_result setObject:@"" forKey:@"name"];
        [_result setObject:@"" forKey:@"init_date"];
        [_result setObject:@"C1" forKey:@"car_type"];
        [_result setObject:@"" forKey:@"number"];
    }
    return @{@"license_id":_result[@"number"],@"name":_result[@"name"],@"init_date":_result[@"init_date"],@"car_type":_result[@"car_type"]};
}
-(BOOL)saveData:(NSDictionary *)paramters{
    NSString *license_id = paramters[@"license_id"];
    if ([license_id length]!=18){
        [[[UIAlertView alloc] initWithTitle:@"易驾366" message:@"身份证号码必须18位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        return NO;
    }
    NSString *temp =[license_id stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    NSLog(@"%@=%d",temp,[temp length]);
    if (([temp length]==0) || (([temp length]==1) && ([license_id hasSuffix:@"X"]))){
        
        
    }else{
        [[[UIAlertView alloc] initWithTitle:@"易驾366" message:@"身份证号码必须18位,只有最后一位允许是X" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        return NO;
    }
    NSString *url =[NSString stringWithFormat:@"api/add_driver_license?user_id=%d&name=%@&license_id=%@&type=%@&init_date=%@",[AppSettings sharedSettings].userid,paramters[@"name"],paramters[@"license_id"],paramters[@"car_type"],paramters[@"init_date"]];
    NSLog(@"%@",url);
    [[HttpClient sharedHttp] get:url  block:^(id json) {
        NSLog(@"%@",json);
        if ([[AppSettings sharedSettings] isSuccess:json]){
            //[self processData:json];
            if (self.delegate){
                [self.delegate processSaveResult:json];
            }
        }
    }];
    return YES;
    
}

@end
@interface DriverLicenseViewController ()<EditDataSourceDelegate>{
    NSArray *_sections;
    NSArray *_items;
    BOOL _isEditing;
    NSMutableDictionary* result;
    EditDriverLicenseDataSource *_datasource;
}

@end

@implementation DriverLicenseViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentInset=UIEdgeInsetsMake(0, 0, 216, 0);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(edit_license:)];
    _isEditing = NO;
    [self setupTableView:self.tableView];
    _datasource = [[EditDriverLicenseDataSource alloc] initWithData:result];
    _datasource.delegate = self;
    
}
-(void)edit_license:(id)sender{
    _datasource.result = result;
    EditTableViewController *vc = [[EditTableViewController alloc] initWithDelegate:_datasource];
    [self.navigationController pushViewController:vc animated:YES];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setTableView:nil];
    [super viewDidUnload];
}
-(void)processSaveResult:(id)json{
    [self processData:json];
}
-(void)initData{
    _sections=@[@"提醒",@"计分情况",@"基本信息"];
    
    _items=@[
    
    
    @[
    @{@"name":@"体检日期",@"key":@"check_date",@"mode":@"",@"description":@"",@"vcname":@""},
    @{@"name":@"换证日期",@"key":@"renew_date",@"mode":@"",@"description":@"",@"vcname":@""}],
    @[@{@"name":@"计分到期日",@"key":@"mark_end_date",@"mode":@"",@"description":@"",@"vcname":@""},
    
    @{@"name":@"计分情况",@"key":@"mark",@"mode":@"",@"description":@"",@"vcname":@""}],
    @[ @{@"name":@"证件号码",@"key":@"number",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"姓名",@"key":@"name",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"准驾车型",@"key":@"car_type",@"mode":@"add",@"description":@"",@"vcname":@"LicenseTypeViewController"},
    @{@"name":@"初领日期",@"key":@"init_date",@"mode":@"add",@"description":@"",@"vcname":@"DatePickerViewController"},
    @{@"name":@"有效期限",@"key":@"end_date",@"mode":@"",@"description":@"",@"vcname":@""}]
    ];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_sections count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_items objectAtIndex:section] count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_sections objectAtIndex:section];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    DisplayTextCell *cell =nil;
    cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        NSArray *cells =[[NSBundle mainBundle] loadNibNamed:@"DisplayTextCell" owner:self.tableView options:nil];
        cell =[cells objectAtIndex:0];
        

    }
    
    id item =[[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *value =[result objectForKey:item[@"key"]];
    cell.keyLabel.text = item[@"name"];
    if (value){
        cell.valueLabel.text =[NSString stringWithFormat:@"%@",value];
    }
    return cell;
    /*
    [cell setValueByKey:item[@"key"] value:value];
    cell.displayLabel.text = item[@"name"];
    cell.valueText.delegate= self;
    if (![item[@"vcname"] isEqualToString:@""]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell start_listen];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.tag = indexPath.row;
    cell.valueText.tag = indexPath.row;
    
    [cell setEditable:_isEditing];
    */
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0){
        PhoneView *phoneView = [[[NSBundle mainBundle] loadNibNamed:@"PhoneView" owner:nil options:nil] objectAtIndex:0];
        [phoneView initWithPhone:_company phone:_phone];
        phoneView.backgroundColor = tableView.backgroundColor;
        return phoneView;
    }else{
        return nil;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0)
        return 80;
    else
        return 22;
}
-(void)setup{
    _helper.url =[[_helper appSetttings] url_get_driver_license];
}
-(void)processData:(id)json{
    id list = json[@"result"];
    NSLog(@"%@",list);
    /* old code
    if ([list isKindOfClass:[NSArray class]] && [list count]>0){
        result =[list objectAtIndex:0];
        
    }
     */
    result =list[@"data"];
    _company = list[@"company"];
    _phone =list[@"phone"];
    [[AppSettings sharedSettings] saveJsonWith:@"license_data" data:result];
    [self.tableView reloadData];
    [self endRefresh:self.tableView];
}
-(void)responseError:(id)json{
    [self endRefresh:self.tableView];
}
@end
