//
//  CarRegistrationViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "CarRegistrationViewController.h"
#import "IllegallyListViewController.h"
#import "DatePickerViewController.h"
#import "DisplayTextCell.h"
#import "PhoneView.h"
#import "OneButtonCell.h"
#import "HttpClient.h"

#import "Browser2Controller.h"

@implementation EditCarReigsterationDataSource

-(id)initWithData:(id)data{
    self = [super init];
    if (self){
        _result = data;
    }
    return self;
}

-(BOOL)saveData:(NSDictionary *)paramters
{
    NSLog(@"%@",paramters);
    
    NSString *url =[NSString stringWithFormat:@"api/add_car_registration?user_id=%d&car_id=%@&vin=%@&init_date=%@&engine_no=%@&owner_name=%@&owner_license=%@",[AppSettings sharedSettings].userid,paramters[@"car_id"],paramters[@"vin"],paramters[@"init_date"],paramters[@"engine_no"],paramters[@"owner_name"],paramters[@"owner_license"]];
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
-(int)textFieldCount{
    return 3;
}
-(NSArray *)getSections{
    return @[@"基本信息"];
}
-(NSArray *)getItems{
    return @[@[ @{@"name":@"车牌号",@"key":@"car_id",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"发动机号",@"key":@"engine_no",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"VIN",@"key":@"vin",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"初登日期",@"key":@"init_date",@"mode":@"add",@"description":@"",@"vcname":@"DatePickerViewController"},
    @{@"name":@"所有人",@"key":@"owner_name",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"所有人证件",@"key":@"owner_license",@"mode":@"add",@"description":@"",@"vcname":@""},
    ]];
}
-(NSDictionary *)getInitData{
    if (!_result){
        _result =[[NSMutableDictionary alloc] init];
        [_result setObject:@"鲁B" forKey:@"plate_no"];
        [_result setObject:@"" forKey:@"engine_no"];
        [_result setObject:@"" forKey:@"vin"];
        [_result setObject:@"" forKey:@"registration_date"];
        [_result setObject:@"" forKey:@"owner_name"];
        [_result setObject:@"" forKey:@"owner_license"];
    }else{
        NSString *plate_no = _result[@"plate_no"];
        if ([plate_no isEqualToString:@""]){
            [_result setObject:@"鲁B" forKey:@"plate_no"];
        }
    }
    return @{@"car_id":_result[@"plate_no"],@"engine_no":_result[@"engine_no"],@"vin":_result[@"vin"],@"init_date":_result[@"registration_date"],@"owner_name":_result[@"owner_name"],@"owner_license":_result[@"owner_license"]};
}
@end

@interface CarRegistrationViewController ()<OneButtonCellDelegate,EditDataSourceDelegate>{
    NSArray *_sections;
    NSArray *_items;
   
    NSMutableDictionary* result;
    EditCarReigsterationDataSource *_datasource;
}

@end

@implementation CarRegistrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initData{
    _sections=@[@"提醒",@"违章信息",@"基本信息",@"4S店"];
    _items=@[
    @[@{@"name":@"年审日期",@"key":@"check_date",@"mode":@"",@"description":@"",@"vcname":@""}],
    @[ @{@"name":@"未处理次数",@"key":@"untreated_number",@"mode":@"",@"description":@"",@"vcname":@""},
    @{@"name":@"未处理记分",@"key":@"untreated_mark",@"mode":@"",@"description":@"",@"vcname":@""},
    @{@"name":@"未处理罚款",@"key":@"untreated_fine",@"mode":@"",@"description":@"",@"vcname":@""},
    @{@"name":@"违章查询",@"key":@"",@"description":@"",@"vcname":@"IllegallyListViewController"}],
    @[ @{@"name":@"车牌号",@"key":@"plate_no",@"mode":@"add",@"description":@"",@"vcname":@""},
    
    @{@"name":@"车辆类型",@"key":@"car_typename",@"mode":@"add",@"description":@"",@"vcname":@""},
    /*@{@"name":@"品牌",@"key":@"brand",@"mode":@"add",@"description":@"",@"vcname":@""},*/
    @{@"name":@"品牌型号",@"key":@"model",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"发动机号",@"key":@"engine_no",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"VIN",@"key":@"vin",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"初登日期",@"key":@"registration_date",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"所有人",@"key":@"owner_name",@"mode":@"add",@"description":@"",@"vcname":@""},
       @{@"name":@"所有人证件",@"key":@"owner_license",@"mode":@"add",@"description":@"",@"vcname":@""},
    ],
    [[NSMutableArray alloc] init]
  ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    self.tableView.delegate = self;
    self.tableView.dataSource = self; self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]  initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
    
    
    [self setupTableView:self.tableView];
    _datasource =[[EditCarReigsterationDataSource alloc] initWithData:result];
    _datasource.delegate = self;
}


-(void)edit:(id)sender{
    _datasource.result = result;
    EditTableViewController *vc = [[EditTableViewController alloc] initWithDelegate:_datasource];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)processSaveResult:(id)json{
    [self processData:json];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)get_illegally:(id)sender {
    IllegallyListViewController *vc =[[IllegallyListViewController alloc] initWithNibName:@"IllegallyListViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setTableView:nil];
    [super viewDidUnload];
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
    
    id item =[[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.section==3){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellIdentifier"];
        cell.textLabel.text = item[@"name"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@(%@)", item[@"address"],item[@"phone"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        if (![item[@"vcname"] isEqualToString:@""]){
            OneButtonCell *cell =[[[NSBundle mainBundle] loadNibNamed:@"OneButtonCell" owner:tableView options:nil] objectAtIndex:0];
            cell.button.text=item[@"name"];
            cell.delegate=self;
            return cell;
            
        }else{
            DisplayTextCell *cell=nil;
            NSArray *cells =[[NSBundle mainBundle] loadNibNamed:@"DisplayTextCell" owner:self.tableView options:nil];
            cell =[cells objectAtIndex:0];
            cell.keyLabel.text = item[@"name"];
            if (![item[@"key"] isEqualToString:@""]){
                NSString *value =[result objectForKey:item[@"key"]];
                if (value){
                    cell.valueLabel.text = [NSString stringWithFormat:@"%@",value];
                }
            }else{
                cell.valueLabel.text=@"";
            }
            cell.tag = indexPath.row;
            cell.valueLabel.tag = indexPath.row;
            return cell;
            
        }
        
    }
    
    
    
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0){
        PhoneView *phoneView = [[[NSBundle mainBundle] loadNibNamed:@"PhoneView" owner:nil options:nil] objectAtIndex:0];
        [phoneView initWithPhone:_company phone:_phone];
        phoneView.backgroundColor = tableView.backgroundColor;
        phoneView.phoneButton.text=@"预约年审";
        return phoneView;
    }else{
        return nil;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0){
        return 80;
    }else{
        return 22;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==3){
        id item =[[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        Browser2Controller *vc = [[Browser2Controller alloc] initWithNibName:@"Browser2Controller" bundle:nil];
        vc.url = item[@"url"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)setup{
    _helper.url =[[_helper appSetttings] url_get_car_registration];
}
-(void)processData:(id)json{
    NSLog(@"%@",json);
    _company = json[@"result"][@"company"];
    _phone = json[@"result"][@"phone"];
    id list = json[@"result"];
    if ([list isKindOfClass:[NSArray class]] && [list count]>0){
        result =[list objectAtIndex:0];
        //NSLog(@"%@ is %@",result,[result class]);
    }else{
        result=list[@"data"];
    }
    [[AppSettings sharedSettings] saveJsonWith:@"car_data" data:result];
    [[_items objectAtIndex:3] removeAllObjects];
    for (id item in list[@"list"]) {
        [[_items objectAtIndex:3] addObject:item];
    }

    [self.tableView reloadData];
    [self endRefresh:self.tableView];
}
-(void)buttonPress:(id)sender{
    IllegallyListViewController *vc =[[IllegallyListViewController alloc] initWithNibName:@"IllegallyListViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)responseError:(id)json{
    [self endRefresh:self.tableView];
}
@end
