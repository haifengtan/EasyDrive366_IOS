//
//  BindCellPhoneViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 5/2/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "BindCellPhoneViewController.h"
#import "AppSettings.h"
#import "HttpClient.h"
#import "OneButtonCell.h"
#import "TextViewFooter.h"

@interface BindCellPhoneViewController (){
    NSTimer *_timer;
    int counter;
    OneButtonCell *_currentCell;
    NSString *_ad;
   
    NSString *_code;
}

@end

@implementation BindCellPhoneViewController

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
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(downCount) userInfo:nil repeats:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textchanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initData{
    NSString *url = [NSString stringWithFormat:@"api/get_sms_ad"];
    [[HttpClient sharedHttp] get:url block:^(id json) {
        _ad= json[@"result"];
        [self init_datasource];
    }];
}
-(void)init_datasource{
   
    id items=@[
    [[NSMutableDictionary alloc] initWithDictionary:
     @{@"key" :@"cellphone",
     @"label":@"手机号码：",
     self.isbind==0?@"disable":@"enable":@"1",
     @"default":@"",
     @"placeholder":@"请输入您的手机号码",
     @"ispassword":@"number",
     @"value":self.phone,
     @"cell":@"EditTextCell"}],
    [[NSMutableDictionary alloc] initWithDictionary:
     @{@"key" :@"get_code",
     @"label":@"获取验证码",
     @"default":@"",
     @"placeholder":@"",
     @"ispassword":@"no",
     @"value":@"",
     @"cell":@"OneButtonCell"  }],
    [[NSMutableDictionary alloc] initWithDictionary:
     @{@"key" :@"code",
     @"label":@"验证码：",
     @"default":@"",
     @"placeholder":@"请输入您的获取的验证码",
     @"ispassword":@"number",
     @"value":@"",
     @"cell":@"EditTextCell"  }],
    [[NSMutableDictionary alloc] initWithDictionary:
     @{@"key" :@"bind",
     @"label":self.isbind==0?@"解除绑定":@"绑定手机",
     @"default":@"",
     @"placeholder":@"",
     @"ispassword":@"no",
     @"value":@"",
     @"cell":@"OneButtonCell"  }],
    
    ];
    
    _list=[NSMutableArray arrayWithArray: @[
           
           @{@"count" : @4,@"list":items,@"height":@44.0f,@"header":@"手机绑定",@"footer":@""},
           
           ]];
    [self.tableView reloadData];
}
/*
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    TextViewFooter *view = [[[NSBundle mainBundle] loadNibNamed:@"TextViewFooter" owner:nil options:nil] objectAtIndex:0];
    view.textview.text = _ad;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 200;
}
*/

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return _ad;
}
-(void)buttonPress:(OneButtonCell *)sender{
    if (sender.tag==1){
        
        if ([_phone length]<11){
            [[[UIAlertView alloc] initWithTitle:AppTitle message:@"请输入正确的手机号码！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil] show];
            return;
        }
        NSString *url = [NSString stringWithFormat:@"api/get_sms_code?userid=%d&phone=%@&isbind=%d",
                         [AppSettings sharedSettings].userid,
                         _phone,
                         self.isbind];
        NSLog(@"%@",url);
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
    }else{
        if ([_code length]==6){
            NSString *url;
            if (self.isbind==1){
                url = [NSString stringWithFormat:@"api/chk_sms_code?userid=%d&code=%@",[AppSettings sharedSettings].userid,_code];
            }else{
                url = [NSString stringWithFormat:@"api/reset_phone?userid=%d&code=%@",[AppSettings sharedSettings].userid,_code];
            }
            [[HttpClient sharedHttp] get:url block:^(id json) {
                if ([[AppSettings sharedSettings] isSuccess:json]){
                    [[[UIAlertView alloc] initWithTitle:AppTitle message:@"操作成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Update_settings" object:nil];
                }
            }];
        }else{
            [[[UIAlertView alloc] initWithTitle:AppTitle message:@"验证码为6位数字，请核实后输入。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil] show];
        }
    }
    
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
-(void)textchanged:(NSNotification *)notification{
   // NSLog(@"%@",notification.object);
    UITextField *field = notification.object;
    if (field.tag==0){
        _phone = field.text;
    }else{
        _code = field.text;
    }
}
@end
