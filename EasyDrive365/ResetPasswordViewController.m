//
//  ResetPasswordViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 4/26/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "HttpClient.h"
#import "AppSettings.h"
#import "OneButtonCell.h"
#import "ButtonViewController.h"
#import "SVProgressHUD.h"

@interface ResetPasswordViewController ()<ButtonViewControllerDelegate>{
    ButtonViewController *_resetController;
}

@end

@implementation ResetPasswordViewController

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
    self.title = @"重设密码";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initData{
    id items=@[
    [[NSMutableDictionary alloc] initWithDictionary:
     @{@"key" :@"oldpassword",
     @"label":@"原密码：",
     @"default":@"",
     @"placeholder":@"原密码",
     @"ispassword":@"yes",
     @"value":@"",
     @"cell":@"EditTextCell"  }],
    [[NSMutableDictionary alloc] initWithDictionary:
     @{@"key" :@"password",
     @"label":@"新密码：",
     @"default":@"",
     @"placeholder":@"新密码",
     @"ispassword":@"yes",
     @"value":@"",
     @"cell":@"EditTextCell"  }],
    [[NSMutableDictionary alloc] initWithDictionary:
     @{@"key" :@"repassword",
     @"label":@"再输一遍：",
     @"default":@"",
     @"placeholder":@"再输一遍",
     @"ispassword":@"yes",
     @"value":@"",
     @"cell":@"EditTextCell"  }]
    
    ];
   
    _list=[NSMutableArray arrayWithArray: @[
           
           @{@"count" : @3,@"list":items,@"height":@44.0f,@"header":@"重设密码",@"footer":@""},
           
           ]];
}
-(void)processSaving:(NSMutableDictionary *)parameters{
    NSLog(@"%@",parameters);
    NSString *oldpassword = [parameters objectForKey:@"oldpassword"];
    if([@"" isEqualToString:oldpassword]){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入原密码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续", nil] show];
        return;
    }
    
    NSString *password = [parameters objectForKey:@"password"];
    if([@"" isEqualToString:password]){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入有效密码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续", nil] show];
        return;
    }
    NSString *repassword=[parameters objectForKey:@"repassword"];
    if(![password isEqualToString:repassword]){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不匹配，请重新输入" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
    }
    
    [[HttpClient sharedHttp] get:[[AppSettings sharedSettings] url_change_password:password oldPassword:oldpassword]  block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码修改成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            //[[[UIAlertView alloc] initWithTitle:@"提示" message:json[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        }
     
    }];
    
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (!_resetController){
        _resetController =[[ButtonViewController alloc] initWithNibName:@"ButtonViewController" bundle:nil];
        _resetController.buttonText=@"重设密码";
        _resetController.buttonType =0;
        _resetController.delegate = self;
    }
    return _resetController.view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80.0f;
}
-(void)buttonPressed:(NVUIGradientButton *)button{
    [self done];
}
@end
