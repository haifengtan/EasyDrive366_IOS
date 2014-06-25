//
//  SettingsViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 4/20/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "SettingsViewController.h"
#import "OneButtonCell.h"
#import "EditTableViewController.h"
#import "MaintanViewController.h"
#import "DriverLicenseViewController.h"
#import "CarRegistrationViewController.h"
#import "HttpClient.h"
#import "AppSettings.h"
#import "ButtonViewController.h"
#import "ResetPasswordViewController.h"
#import "BindCellPhoneViewController.h"
#import "SVProgressHUD.h"
#import "FeedbackViewController.h"
#import "ActivateViewController.h"
#import "ShowActivateViewController.h"
#import "ShowActivateTableController.h"
#import "SignupStep1ViewController.h"
#import "NewActivateViewController.h"
#import "CardViewController.h"
#import "AddCardStep1ControllerViewController.h"
#import "FeedbackController2.h"
#import "UserProfileView.h"
#import "NeedPayController.h"
#import "MyFavorController.h"
#import "MyHistroyController.h"
#import "UserProfileController.h"

#define SECTION_LAST 5


@interface SettingsViewController ()<ButtonViewControllerDelegate,UIAlertViewDelegate>{
    EditMaintainDataSource *_maintainDatasource;
    EditDriverLicenseDataSource *_driverDatasource;
    EditCarReigsterationDataSource *_carDatasource;
    ButtonViewController *logoutView;
    NSString *_phone;
    NSString *_phoneStatus;
    int isbind;
    BOOL _isActive;
    
    NSString *_number;
    NSString *_code;
    NSString *_activate_date;
    NSString *_valid_date;
    id contents;
    UserProfileView *_headerView;
    UIRefreshControl *_refreshControl;
}

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
    self.title = @"用户";
    
    _maintainDatasource = [[EditMaintainDataSource alloc] initWithData: [[AppSettings sharedSettings] loadJsonBy:@"maintain_data"]];
    
    _driverDatasource =[[EditDriverLicenseDataSource alloc] initWithData:[[AppSettings sharedSettings] loadJsonBy:@"license_data"]];
    
    _carDatasource =[[EditCarReigsterationDataSource alloc] initWithData:[[AppSettings sharedSettings] loadJsonBy:@"car_data"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:@"Update_settings" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update_user_profile) name:UPDATE_USER_PROFILE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:LOGIN_SUCCESS object:nil];
    //[self.tableView setBackgroundColor:[UIColor clearColor]];
    _refreshControl= [[UIRefreshControl alloc] init];
    self.refreshControl = _refreshControl;
    [_refreshControl addTarget:self action:@selector(refreshUser) forControlEvents:UIControlEventValueChanged];
}
-(void)refreshUser{
    [self update_user_profile];
    [_refreshControl endRefreshing];
}
-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)update_user_profile{
    [_headerView load_data:self.taskid];
}

-(void)initData{
    NSString *url;
    
    if (self.taskid>0)
        url = [NSString stringWithFormat:@"api/get_user_phone?userid=%d&taskid=%d",[AppSettings sharedSettings].userid,self.taskid];
    else
        url =[NSString stringWithFormat:@"api/get_user_phone?userid=%d",[AppSettings sharedSettings].userid];
    
     _phoneStatus = @"绑定手机";
    _phone = @"";
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            NSLog(@"%@",json);
            _number= json[@"result"][@"number"];
            _code = json[@"result"][@"code"];
            _activate_date =json[@"result"][@"activate_date"];
            _valid_date =json[@"result"][@"valid_date"];
            if (json[@"result"][@"contents"]){
                contents = json[@"result"][@"contents"];
            }
            _isActive = ![_code isEqual:@""];
            _phone=json[@"result"][@"phone"];
            isbind = 1;
            if ([json[@"result"][@"status"] isEqual:@"02"]){
                _phoneStatus = @"解除绑定";
                isbind = 0;
        
            }            
        }
        [_headerView load_data:self.taskid];
        [self init_dataSource];
        
    }];
    
    
    
}
-(void)loadActivateStatus{
    NSString *url = [NSString stringWithFormat:@"api/had_activate_code?userid=%d",[AppSettings sharedSettings].userid];
    _isActive = NO;

    [[AppSettings sharedSettings].http get:url block:^(id json) {
        NSLog(@"%@",json);
        if ([[AppSettings sharedSettings] isSuccess:json]){
            if (_list){
                id item = [[_list objectAtIndex:3] objectAtIndex:2];
                item[@"value"]=@"已经激活";
                [self.tableView reloadData];
            }
            
            
            _isActive = YES;
        }else{
            
        }
        
        [self init_dataSource];
        
    }];
}
-(void)init_dataSource{
    /*
    id items_new=@[
                [[NSMutableDictionary alloc] initWithDictionary:
                 @{@"key" :@"card_view",
                 @"label":@"保险卡单查看",
                 @"default":@"",
                 @"placeholder":@"",
                 @"value":@"",
                 @"cell":@"ChooseNextCell" }],
                [[NSMutableDictionary alloc] initWithDictionary:
                 @{@"key" :@"card_setup",
                 @"label":@"保险卡单激活",
                 @"default":@"",
                 @"placeholder":
                 @"",@"value":@"",
                 @"cell":@"ChooseNextCell" }]
                ];
     */
    id items0=@[
                [[NSMutableDictionary alloc] initWithDictionary:
                 @{@"key" :@"feedback",
                 @"label":@"意见反馈",
                 @"default":@"",
                 @"placeholder":@"",
                 @"ispassword":@"",
                 @"value":@"",
                 @"cell":@"ChooseNextCell"}]
                ];
    id items1=@[
                   [[NSMutableDictionary alloc] initWithDictionary:
                    @{@"key" :@"order",
                    @"label":@"我的订单",
                    @"default":@"",
                    @"placeholder":@"",
                    @"value":@"",
                    @"cell":@"ChooseNextImageCell",@"icon":@"a.png" }],
                   [[NSMutableDictionary alloc] initWithDictionary:
                    @{@"key" :@"card",
                    @"label":@"我的卡券",
                    @"default":@"",
                    @"placeholder":
                    @"",@"value":@"",
                    @"cell":@"ChooseNextImageCell",@"icon":@"b.png" }],
                   [[NSMutableDictionary alloc] initWithDictionary:
                    @{@"key" :@"favorite",
                    @"label":@"我的收藏",
                    @"default":@"",
                    @"placeholder":@"",
                    @"value":@"",
                    @"cell":@"ChooseNextImageCell",@"icon":@"c.png" }],
                   [[NSMutableDictionary alloc] initWithDictionary:
                    @{@"key" :@"histroy",
                    @"label":@"浏览历史",
                    @"default":@"",
                    @"placeholder":
                    @"",@"value":@"",
                    @"cell":@"ChooseNextImageCell",@"icon":@"d.png" }]
                   ];
    id items2=@[
                [[NSMutableDictionary alloc] initWithDictionary:
                 @{@"key" :@"car_register",
                 @"label":@"我的车辆",
                 @"default":@"",
                 @"placeholder":
                 @"",@"value":@"",
                 @"cell":@"ChooseNextImageCell",@"icon":@"e.png" }],
                [[NSMutableDictionary alloc] initWithDictionary:
                 @{@"key" :@"driver",
                 @"label":@"驾驶证",
                 @"default":@"",
                 @"placeholder":
                 @"",@"value":@"",
                 @"cell":@"ChooseNextImageCell",@"icon":@"f.png" }],
                [[NSMutableDictionary alloc] initWithDictionary:
                 @{@"key" :@"maintain",
                 @"label":@"保养设置",
                 @"default":@"",
                 @"placeholder":@"",
                 @"value":@"",
                   @"cell":@"ChooseNextImageCell",@"icon":@"g.png" }],
                [[NSMutableDictionary alloc] initWithDictionary:
                 @{@"key" :@"profile",
                   @"label":@"我的资料",
                   @"default":@"",
                   @"placeholder":@"",
                   @"value":@"",
                   @"cell":@"ChooseNextImageCell",@"icon":@"p.png" }]
                ];
    
    id items3= @[
                  [[NSMutableDictionary alloc] initWithDictionary:
                   @{@"key" :@"resetpassword",
                   @"label":@"重设密码",
                   @"default":@"",
                   @"placeholder":
                   @"",@"value":@"",
                   @"cell":@"ChooseNextImageCell",@"icon":@"h.png" }],
                  [[NSMutableDictionary alloc] initWithDictionary:
                   @{@"key" :@"cellphone",
                   @"label":_phoneStatus,
                   @"default":@"",
                   @"placeholder":@"",
                   @"ispassword":@"",
                   @"value":_phone,
                   @"cell":@"ChooseNextImageCell",@"icon":@"i.png"  }],
                  [[NSMutableDictionary alloc] initWithDictionary:
                   @{@"key" :@"find_password",
                   @"label":@"找回密码",
                   @"default":@"",
                   @"placeholder":
                   @"",@"value":@"",
                   @"cell":@"ChooseNextImageCell",@"icon":@"j.png" }]];
    id items4=@[[[NSMutableDictionary alloc] initWithDictionary:
                 @{@"key" :@"version",
                 @"label":@"版本号",
                 @"default":@"",
                 @"placeholder":@"",
                 @"ispassword":@"",
                 @"value":[NSString stringWithFormat:@"V%@",AppVersion],
                 @"cell":@"ChooseNextCell"  }]];
    
    id items5=@[[[NSMutableDictionary alloc] initWithDictionary:
                 @{@"key" :@"setup",
                 @"label":@"设置向导",
                 @"default":@"",
                 @"placeholder":
                 @"",@"value":@"",
                 @"cell":@"ChooseNextCell" }]];
    
    
    
    _list=[NSMutableArray arrayWithArray: @[
           @{@"count" : @1,@"list":items0,@"height":@44.0f,@"header":@"",@"footer":@""},
           @{@"count" : @4,@"list":items1,@"height":@44.0f,@"header":@"",@"footer":@""},
           @{@"count" : @4,@"list":items2,@"height":@44.0f,@"header":@"",@"footer":@""},
           @{@"count" : @3,@"list":items3,@"height":@44.0f,@"header":@"",@"footer":@""},
           @{@"count" : @1,@"list":items4,@"height":@44.0f,@"header":@"",@"footer":@""},
           @{@"count" : @1,@"list":items5,@"height":@44.0f,@"header":@"",@"footer":@""},
           ]];
    [self.tableView reloadData];
}
-(void)setupCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    [super setupCell:cell indexPath:indexPath];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     
     
     
     */
    NSString *key =[[_list objectAtIndex:indexPath.section][@"list"] objectAtIndex:indexPath.row][@"key"];
    if ([key isEqualToString:@"feedback"]){
        FeedbackController2 *vc = [[FeedbackController2 alloc] initWithStyle:UITableViewStyleGrouped];
        vc.title = @"意见反馈";
        
        [self.navigationController pushViewController:vc animated:YES];
        if (isbind==0){
            //vc.txtCommunication.text =_phone;
        }
    }else if ([key isEqualToString:@"order"]){
        NeedPayController *vc = [[NeedPayController alloc] initWithStyle:UITableViewStylePlain];
        vc.status = @"finished";
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([key isEqualToString:@"card"]){
        NewActivateViewController *vc =[[NewActivateViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([key isEqualToString:@"favorite"]){
        MyFavorController *vc = [[MyFavorController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([key isEqualToString:@"histroy"]){
        MyHistroyController *vc = [[MyHistroyController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([key isEqualToString:@"car_register"]){
        [self open_car_setup];
    }else if ([key isEqualToString:@"driver"]){
        [self open_driver_setup];
    }else if ([key isEqualToString:@"maintain"]){
        [self open_maintain_setup];
    }else if ([key isEqualToString:@"resetpassword"]){
        ResetPasswordViewController *vc = [[ResetPasswordViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([key isEqualToString:@"cellphone"]){
        BindCellPhoneViewController *vc =[[BindCellPhoneViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.isbind = isbind;
        vc.phone = _phone;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([key isEqualToString:@"find_password"]){
        if (isbind==1){
            //unbind cellphone
            UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:AppTitle message:@"找回密码操作需要绑定手机，请先绑定手机。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }else{
            UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:AppTitle message:@"找回密码操作将向您绑定手机发送随机初始密码（短信免费），请确认要找回密码？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            
        }
    }else if ([key isEqualToString:@"version"]){
        [AppSettings sharedSettings].isCancelUpdate = NO;
        [[AppSettings sharedSettings] check_update:YES];
    }else if ([key isEqualToString:@"setup"]){
        [self register_step];
    }else if ([key isEqualToString:@"profile"]){
        UserProfileController *vc = [[UserProfileController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
        //[super tableView:tableView didSelectRowAtIndexPath:indexPath];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (isbind==1){
        //unbind cellphone
        if (buttonIndex==1){
            BindCellPhoneViewController *vc =[[BindCellPhoneViewController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.isbind = isbind;
            vc.phone = _phone;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        if (buttonIndex==1){
            NSString *url = [NSString stringWithFormat:@"api/sms_reset_pwd?userid=%d",[AppSettings sharedSettings].userid];
            [[HttpClient sharedHttp] get:url block:^(id json) {
                NSLog(@"%@",json);
                if ([[AppSettings sharedSettings] isSuccess:json]){
                    [[[UIAlertView alloc] initWithTitle:AppTitle message:json[@"result"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil] show];
                    
                    ResetPasswordViewController *vc = [[ResetPasswordViewController alloc] initWithStyle:UITableViewStyleGrouped];
                   
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else{
                
                }
            }];
        }
    }
}

-(void)open_maintain_setup{
    NSString *url =[[AppSettings sharedSettings] url_for_get_maintain_record];
    [[HttpClient sharedHttp] get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            id temp=[json objectForKey:@"result"][@"data"];
            
            NSLog(@"%@",temp);
            NSEnumerator *enumerator =[temp keyEnumerator];
            id key;
            id result = [[NSMutableDictionary alloc] init];
            while ((key=[enumerator nextObject])) {
                id value = [temp objectForKey:key];
                if ([value isKindOfClass:[NSNull class]]){
                    [result setObject:@"" forKey:key];
                    
                }else{
                    [result setObject:value?value:@"" forKey:key];
                }
            }
            _maintainDatasource = [[EditMaintainDataSource alloc] initWithData:result];
            EditTableViewController *vc = [[EditTableViewController alloc] initWithDelegate:_maintainDatasource];
            [self.navigationController pushViewController:vc animated:YES];
        }
       
    }];
}
-(void)open_driver_setup{
    NSString *url =[[AppSettings sharedSettings] url_get_driver_license];
    [[HttpClient sharedHttp] get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            id result=[json objectForKey:@"result"][@"data"];
            
            
            _driverDatasource = [[EditDriverLicenseDataSource alloc] initWithData:result];
            EditTableViewController *vc = [[EditTableViewController alloc] initWithDelegate:_driverDatasource];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
}
-(void)register_step{
    SignupStep1ViewController *vc = [[SignupStep1ViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)open_car_setup{
    NSString *url =[[AppSettings sharedSettings] url_get_car_registration];
    [[HttpClient sharedHttp] get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            id result=[json objectForKey:@"result"][@"data"];
            
            
            _carDatasource = [[EditCarReigsterationDataSource alloc] initWithData:result];
            EditTableViewController *vc = [[EditTableViewController alloc] initWithDelegate:_carDatasource];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
}

-(void)buttonPressed:(NVUIGradientButton *)button{
    [self.navigationController popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==SECTION_LAST){
        if (!logoutView){
            [logoutView removeFromParentViewController];
        }
        logoutView = [[ButtonViewController alloc] initWithNibName:@"ButtonViewController" bundle:nil];
        logoutView.buttonText=[NSString stringWithFormat:@"注销--%@",[AppSettings sharedSettings].firstName];
        
        logoutView.delegate = self;
        logoutView.buttonType =1;
        
        return logoutView.view;
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==SECTION_LAST){
        return 80;
    }else{
        return 11;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0){
        if (!_headerView){
            _headerView =[[UserProfileView alloc] initWithController:self.navigationController taskid:self.taskid];
        } 
        return _headerView;
    }else
        return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0){
        return 180;
    }else{
        return 11;
    }
}
@end
