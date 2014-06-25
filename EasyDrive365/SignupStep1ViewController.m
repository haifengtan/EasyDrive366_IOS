//
//  SignupStep1ViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 8/6/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "SignupStep1ViewController.h"
#import "HttpClient.h"
#import "AppSettings.h"
#import "SignupStep2ViewController.h"


@interface SignupStep1ViewController ()

@end

@implementation SignupStep1ViewController
-(void)init_setup{
    _saveButtonName = @"下一步";
    self.header_text =@"设置向导第1步共4步";
    
}
-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initData{
    if (self.commingFrom){

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.commingFrom style:UIBarButtonSystemItemAction target:self action:@selector(backTo)];
    }
    NSString *url;
    if (self.taskid>0)
        url = [NSString stringWithFormat:@"api/wizardstep0?userid=%d&taskid=%d",[AppSettings sharedSettings].userid,self.taskid];
    else
        url = [NSString stringWithFormat:@"api/wizardstep0?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if (!self.remark_text)
            self.remark_text = json[@"result"][@"remark"];
        id items=@[
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"car_id",@"label":@"车牌号：",@"default":@"",@"placeholder":@"鲁BFK982",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":json[@"result"][@"car_id"] }],
                   
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"vin",@"label":@"VIN后四位：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":json[@"result"][@"vin"] }],
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"id_no",@"label":@"身份证号：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":json[@"result"][@"license_id"] }],
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"phone",@"label":@"手机号：",@"default":@"",@"placeholder":@"",@"ispassword":@"number",@"cell":@"EditTextCell",@"value":json[@"result"][@"phone"] }]
                   ];
        _list=[NSMutableArray arrayWithArray: @[
               /*@{@"count" : @1,@"list":@[@{@"cell":@"IntroduceCell"}],@"height":@100.0f},*/
               @{@"count" : @4,@"list":items,@"height":@44.0f},
               //@{@"count" : @1,@"cell":@"OneButtonCell",@"list":@[],@"height":@44.0f}
               ]];
        [self.tableView reloadData];
    }];
    
    self.title = @"设置向导";
}


-(void)setupCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    [super setupCell:cell indexPath:indexPath];
}
-(void)processSaving:(NSMutableDictionary *)parameters{
    NSLog(@"%@",parameters);
    NSString *car_id=[parameters objectForKey:@"car_id"];
    if([@"" isEqualToString:car_id]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"车牌号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
    }
    NSString *vin=[parameters objectForKey:@"vin"];
    if([@"" isEqualToString:car_id]){
       /* [[[UIAlertView alloc] initWithTitle:AppTitle message:@"车牌号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        */
    }
    NSString *license_id = [parameters objectForKey:@"id_no"];
    if([@"" isEqualToString:license_id]){
        /*
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"身份证号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续", nil] show];
        return;
         */
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
    
    NSString *path =[NSString stringWithFormat:@"api/wizardstep1?userid=%d&car_id=%@&license_id=%@&vin=%@&phone=%@",[AppSettings sharedSettings].userid, car_id,license_id,vin,phone];
    
    [[HttpClient sharedHttp] get:path block:^(id json) {
        NSLog(@"%@",json);
        if ([[AppSettings sharedSettings] isSuccess:json]){
            SignupStep2ViewController *vc = [[SignupStep2ViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [AppSettings sharedSettings].userid=[json[@"result"][@"userid"] intValue];
            vc.vin=json[@"result"][@"vin"];
            vc.engine_no =json[@"result"][@"engine_no"];
            vc.registration_date=json[@"result"][@"registration_date"];
            vc.owner_name=json[@"result"][@"owner_name"];
            vc.remark_text = json[@"result"][@"remark"];
            vc.owner_license =json[@"result"][@"owner_license"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

@end
