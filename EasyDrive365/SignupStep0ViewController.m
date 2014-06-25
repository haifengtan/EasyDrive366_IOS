//
//  SignupStep0ViewController.m
//  EasyDrive366
//
//  Created by Steven Fu on 5/10/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "SignupStep0ViewController.h"
#import "AppSettings.h"
#import "SignupStep1ViewController.h"

@interface SignupStep0ViewController ()

@end

@implementation SignupStep0ViewController

-(void)init_setup{
    _saveButtonName = @"下一步";
    
}
-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initData{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonSystemItemAction target:self action:@selector(backTo)];
    
    NSString *url;
    if (self.taskid>0)
        url = [NSString stringWithFormat:@"api/wizardstep?userid=%d&taskid=%d",[AppSettings sharedSettings].userid,self.taskid];
    else
        url = [NSString stringWithFormat:@"api/wizardstep?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        id items=@[
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"car_id",@"label":@"车牌号：",@"default":@"",@"placeholder":@"鲁BFK982",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":json[@"result"][@"car_id"] }],
                   
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"invite_code",@"label":@"邀请码：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":json[@"result"][@"invite_code"] }],
                 
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"phone",@"label":@"手机号：",@"default":@"",@"placeholder":@"",@"ispassword":@"number",@"cell":@"EditTextCell",@"value":json[@"result"][@"phone"] }]
                   ];
        _list=[NSMutableArray arrayWithArray: @[
                                                /*@{@"count" : @1,@"list":@[@{@"cell":@"IntroduceCell"}],@"height":@100.0f},*/
                                                @{@"count" : @3,@"list":items,@"height":@44.0f},
                                                //@{@"count" : @1,@"cell":@"OneButtonCell",@"list":@[],@"height":@44.0f}
                                                ]];
        [self.tableView reloadData];
    }];
    
    self.title = @"设置向导";
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section==0){
        return @"";
    }else{
        return  Nil;
    }
}

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)processSaving:(NSMutableDictionary *)parameters{

    NSString *car_id=[parameters objectForKey:@"car_id"];
    if([@"" isEqualToString:car_id]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"车牌号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
    }
    NSString *invite_code=[parameters objectForKey:@"invite_code"];
    if([@"" isEqualToString:invite_code]){
        /* [[[UIAlertView alloc] initWithTitle:AppTitle message:@"车牌号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
         return;
         */
    }
    /*
     
    NSString *license_id = [parameters objectForKey:@"id_no"];
    if([@"" isEqualToString:license_id]){
     
    }else{
        if ([license_id length]!=18){
            [[[UIAlertView alloc] initWithTitle:@"易驾366" message:@"身份证号码必须18位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            return;
        }
        NSString *temp =[license_id stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
        NSLog(@"%@=%d",temp,[temp length]);
        if (([temp length]==0) || (([temp length]==1) && ([license_id hasSuffix:@"X"]))){
            
            
        }else{
            [[[UIAlertView alloc] initWithTitle:@"易驾366" message:@"身份证号码必须18位,只有最后一位允许是X" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            return;
        }
    }
*/
    NSString *phone=[parameters objectForKey:@"phone"];
    if([@"" isEqualToString:phone]){
        /* [[[UIAlertView alloc] initWithTitle:AppTitle message:@"手机号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
         return;
         */
    }
    
    /*
     SignupStep2ViewController *vc = [[SignupStep2ViewController alloc] initWithStyle:UITableViewStyleGrouped];
     vc.vin=@"vin";
     vc.engine_no =@"aab";
     vc.registration_date=@"2010-01-01";
     [self.navigationController pushViewController:vc animated:YES];
     return;
     */
    
    NSString *path =[NSString stringWithFormat:@"api/wizardstep0?userid=%d&car_id=%@&invite_code=%@&phone=%@&sign=1",[AppSettings sharedSettings].userid, car_id,invite_code,phone];
    
    [[HttpClient sharedHttp] get:path block:^(id json) {
        NSLog(@"%@",json);
        if ([[AppSettings sharedSettings] isSuccess:json]){
            SignupStep1ViewController *vc = [[SignupStep1ViewController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.commingFrom = @"上一步";
            vc.remark_text = json[@"result"][@"remark"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}


@end
