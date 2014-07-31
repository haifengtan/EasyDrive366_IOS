//
//  ForgotPassword2TableViewController.m
//  EasyDrive366
//
//  Created by admin on 14-7-31.
//  Copyright (c) 2014年 Fu Steven. All rights reserved.
//

#import "ForgotPassword2TableViewController.h"
#import "HttpClient.h"
#import "AppSettings.h"
#import "OneButtonCell.h"
NSString *inform5=@"找回密码";
@interface ForgotPassword2TableViewController (){
    NSTimer *_timer;
    int counter;
    OneButtonCell *_currentCell;
    NSString *_ad;
    
    NSString *_code;
}

@end

@implementation ForgotPassword2TableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
      _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(downCount) userInfo:nil repeats:YES];
}

-(void)init_setup{
    _saveButtonName = @"提交";
}
-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initData{
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录和注册" style:UIBarButtonSystemItemAction target:self action:@selector(backTo)];
    id items=@[
               [[NSMutableDictionary alloc] initWithDictionary:
                @{@"key" :@"userPhone",
                  @"label":@"手机号码：",
                  @"disable":@"1",
                  @"default":@"",
                  @"placeholder":@"请输入您的手机号码",
                  @"ispassword":@"number",
                  @"value":_userPhone,
                  @"cell":@"EditTextCell"}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"userPassword",@"label":@"新密码：",@"default":@"",@"placeholder":@"",@"ispassword":@"yes",@"cell":@"EditTextCell",@"value":@"" }],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"confirmPassword",@"label":@"确认密码：",@"default":@"",@"placeholder":@"",@"ispassword":@"yes",@"cell":@"EditTextCell",@"value":@"" }],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"verificationCode",@"label":@"验证码：",@"default":@"",@"placeholder":@"验证码",@"ispassword":@"no",@"cell":@"EditTextCell",@"value":@"" }],
               [[NSMutableDictionary alloc] initWithDictionary:
                @{@"key" :@"get_code",
                  @"label":@"获取验证码",
                  @"default":@"",
                  @"placeholder":@"",
                  @"ispassword":@"no",
                  @"value":@"",
                  @"cell":@"OneButtonCell"  }]
               ];
    _list=[NSMutableArray arrayWithArray: @[
                                            @{@"count" : @1,@"list":@[@{@"cell":@"IntroduceCell"}],@"height":@100.0f},
                                            @{@"count" : @5,@"list":items,@"height":@44.0f},
                                            ]];
}
-(void)setupCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    [super setupCell:cell indexPath:indexPath];
}
-(void)processSaving:(NSMutableDictionary *)parameters{
    NSLog(@"%@",parameters);
        NSString *password = [parameters objectForKey:@"userPassword"];
    if([@"" isEqualToString:password]){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入有效密码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续", nil] show];
        return;
    }
    NSString *repassword = [parameters objectForKey:@"confirmPassword"];
    if (![repassword isEqualToString:password]){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不匹配，请重新输入" delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续", nil] show];
        return;
    }
    
     NSString *verificationCode = [parameters objectForKey:@"verificationCode"];
    if([@"" isEqualToString:verificationCode]){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入有效验证码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续", nil] show];
        return;
    }
    
    NSString *path =[NSString stringWithFormat:@"api/signup?username=%@&password=%@",_username,password];
    
//    [[HttpClient sharedHttp] get:path block:^(id json) {
//        NSLog(@"%@",json);
//        if (json){
//            NSString *status =[json objectForKey:@"status"];
//            if (status && [status isEqualToString:@"success"]){
//                
//                NSNumber *userid=[[json objectForKey:@"result"] objectForKey:@"id"];
//                
//                [[AppSettings sharedSettings] login:_username userid:[userid intValue]];
//                [[AppSettings sharedSettings] add_login:_username password:password rememberPassword:@"1"];
//                //[[AppSettings sharedSettings] login:username userid:65];
//                
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            }else{
////                self.lblInfor.text = [json objectForKey:@"message"];
//                [[[UIAlertView alloc] initWithTitle:@"提示" message:[json objectForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续", nil] show];
//            }
//        }
//    }];
    [AppSettings sharedSettings].userid =1601;
    [[HttpClient sharedHttp] get:[[AppSettings sharedSettings] url_change_password:password oldPassword:password]  block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码修改成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [[[UIAlertView alloc] initWithTitle:@"提示" message:json[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        }
        
    }];
}

-(void)buttonPress:(OneButtonCell *)sender{
    
    NSString *url = [NSString stringWithFormat:@"api/get_sms_code?userid=%d&phone=%@&isbind=%d",
                     1601,
                     _userPhone,
                     0];
    [[HttpClient sharedHttp] get:url block:^(id json) {
        NSLog(@"%@",json);
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _currentCell = sender;
            counter=60;
            _currentCell.button.enabled = NO;
        }else{
            //[[[UIAlertView alloc] initWithTitle:AppTitle message:json[@"message"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil] show];
        }
    }];
    
}

-(void)downCount{
    if (_currentCell){
        _currentCell.button.disabledText = [NSString stringWithFormat:@"重新获取验证码(%d)",counter];
        
        counter--;
        if (counter<=0){
            _currentCell.button.enabled = YES;
            _currentCell.button.text =@"获取验证码";
            _currentCell = nil;
        }
        
        
    }
    
}
@end

