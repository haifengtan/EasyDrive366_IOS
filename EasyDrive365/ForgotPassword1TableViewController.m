//
//  ForgotPassword1TableViewController.m
//  EasyDrive366
//
//  Created by admin on 14-7-31.
//  Copyright (c) 2014年 Fu Steven. All rights reserved.
//

#import "ForgotPassword1TableViewController.h"
#import "HttpClient.h"
#import "AppSettings.h"
#import "OneButtonCell.h"
#import "ForgotPassword2TableViewController.h"
@interface ForgotPassword1TableViewController ()

@end

@implementation ForgotPassword1TableViewController

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
    self.title=@"找回密码";
}

-(void)init_setup{
    _saveButtonName = @"下一步";
}
-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initData{
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录和注册" style:UIBarButtonSystemItemAction target:self action:@selector(backTo)];
    id items=@[
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"username",
                                                                 @"label":@"用户名：",
                                                                 @"default":@"",
                                                                 @"placeholder":@"请输入用户名",
                                                                 @"ispassword":@"no",
                                                                 @"cell":@"EditTextCell",
                                                                 @"value":@"" }],
               ];
    _list=[NSMutableArray arrayWithArray: @[
                                            @{@"count" : @1,@"list":@[@{@"cell":@"IntroduceCell"}],@"height":@100.0f},
                                            @{@"count" : @1,@"list":items,@"height":@44.0f},
                                            ]];
}
-(void)setupCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    [super setupCell:cell indexPath:indexPath];
}

/**
 *  点击下一步   获取用户的手机号码   然后跳转到下一个也没
 *
 *  @param parameters <#parameters description#>
 */
-(void)processSaving:(NSMutableDictionary *)parameters{
    NSLog(@"%@",parameters);
    NSString *username=[parameters objectForKey:@"username"];
    if([@"" isEqualToString:username]){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名称不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
    }
    
    NSString *path =[NSString stringWithFormat:@"api/get_user_phone_by_userName?user_name=%@",username];
    
    [[HttpClient sharedHttp] get:path block:^(id json) {
        if (json){
            NSString *status =[json objectForKey:@"status"];
            if (status && [status isEqualToString:@"success"]){
                //测试
                NSString*phone=json[@"result"][@"user_phone"];
                
                NSString*userID=json[@"result"][@"user_id"];
                //                 NSString*phone=json[@"result"];
                //                NSString*userID=json[@"result"];
                //
                //                phone =@"15610050368";
                //                userID=@"1601";
                ForgotPassword2TableViewController *vc = [[ForgotPassword2TableViewController alloc]initWithStyle:UITableViewStyleGrouped];
                vc.userPhone = phone;
                vc.userID = userID;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [[[UIAlertView alloc] initWithTitle:@"提示" message:[json objectForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续", nil] show];
            }
        }
    }];
}

@end
