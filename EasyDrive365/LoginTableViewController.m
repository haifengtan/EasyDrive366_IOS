//
//  LoginTableViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 3/8/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "LoginTableViewController.h"
#import "HttpClient.h"
#import "AppSettings.h"
#import "ChooseUserController.h"

@interface LoginTableViewController(){
    NSString *_username;
    NSString *_password;
    NSString *_remember;
}

@end
@implementation LoginTableViewController


-(void)viewDidLoad{
    
    NSMutableArray *list =[[AppSettings sharedSettings] get_logins];
    if (list &&  [list count]>0){
        id user = [list objectAtIndex:[list count]-1];
        [self setupLoginUser:user];
    }else{
        _username=@"";
        _password=@"";
        _remember=@"1";
    }
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseUser:) name:@"Choose_user" object:nil];
}
-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}
-(void)setupLoginUser:(id)user{
    _remember = user[@"remember"];
    _username = user[@"username"];
    _password = user[@"password"];
    if ([_remember isEqualToString:@"0"]){
        _password = @"";
    }
}
-(void)chooseUser:(NSNotification *)notification{
    NSLog(@"%@",notification.object);
    [self setupLoginUser:notification.object];
    if ([_remember isEqualToString:@"1"]){
        //[self login:_username password:_password remember:_remember];
        [[AppSettings sharedSettings] login:_username password:_password remember:_remember callback:^(BOOL loginSuccess) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }else{
        [self initData];
        [self.tableView reloadData];
    }
    
}

-(void)initData{
    id items=@[
            [[NSMutableDictionary alloc] initWithDictionary:
             @{@"key" :@"username",
               @"label":@"用户名：",
               @"default":@"",
               @"placeholder":@"手机号/车牌号",
               @"ispassword":@"no",
                @"value":_username,
             @"cell":@"EditTextCell"  }],
            [[NSMutableDictionary alloc] initWithDictionary:
             @{@"key" :@"password",
             @"label":@"密码：",
             @"default":@"",
             @"placeholder":@"",
             @"ispassword":@"yes",
             @"value":_password,
             @"cell":@"EditTextCell"  }]
    
    ];
    id items2=@[
        [[NSMutableDictionary alloc] initWithDictionary:
         @{@"key" :@"remember",@"label":@"记住密码",@"default":@"",@"placeholder":@"",@"value":_remember,@"cell":@"SwitchCell" }],
            [[NSMutableDictionary alloc] initWithDictionary: @{@"key" :@"choose_next",@"label":@"选择曾经登录用户",@"default":@"",@"placeholder":@"",@"value":@"",@"cell":@"ChooseNextCell" }]];
    _list=[NSMutableArray arrayWithArray: @[
           @{@"count" : @1,@"list":@[@{@"cell":@"IntroduceCell"}],@"height":@100.0f},
           @{@"count" : @2,@"list":items,@"height":@44.0f},
           @{@"count" : @2,@"list":items2,@"height":@44.0f},
           ]];
}
-(void)setupCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    [super setupCell:cell indexPath:indexPath];
}
-(void)processSaving:(NSMutableDictionary *)parameters{
    NSLog(@"%@",parameters);
    
    NSString *username=[parameters objectForKey:@"username"];
    if([@"" isEqualToString:username]){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名称不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
    }
    NSString *password = [parameters objectForKey:@"password"];
    if([@"" isEqualToString:password]){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入有效密码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续", nil] show];
        return;
    }
    NSString *remember = [parameters objectForKey:@"remember"];
    
    //[self login:username password:password remember:remember];
    [[AppSettings sharedSettings] login:username password:password remember:remember callback:^(BOOL loginSuccess) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}
/*
- (void)login:(NSString *)username password:(NSString *)password remember:(NSString *)remember {
    //[self doLogin];
    NSString *path  =[NSString stringWithFormat:@"api/login?username=%@&password=%@",username,password];
    [[HttpClient sharedHttp] get:path block:^(id json) {
        if (json){
            NSString *status =[json objectForKey:@"status"];
            if (status && [status isEqualToString:@"success"]){
                //success login
                
                NSNumber *userid=[[json objectForKey:@"result"] objectForKey:@"id"];

                [[AppSettings sharedSettings] login:username userid:[userid intValue]];
                [[AppSettings sharedSettings] add_login:username password:password rememberPassword:remember];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                
            }else{
                //self.txtUsername.text = [json objectForKey:@"message"];
                //[[[UIAlertView alloc] initWithTitle:@"提示" message:[json objectForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续", nil] show];
            }
        }
    }];
    
}
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2 && indexPath.row==1){
        ChooseUserController *vc = [[ChooseUserController alloc] initWithNibName:@"ChooseUserController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    NSLog(@"%@",indexPath);
    //[super tableView:tableView didSelectRowAtIndexPath:indexPath];
}
@end
