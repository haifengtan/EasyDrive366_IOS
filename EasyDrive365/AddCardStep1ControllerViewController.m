//
//  AddCardStep1ControllerViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 10/22/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "AddCardStep1ControllerViewController.h"
#import "AppSettings.h"
#import "AddCardStep2Controller.h"

@interface AddCardStep1ControllerViewController ()

@end

@implementation AddCardStep1ControllerViewController

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
-(void)init_setup{
    _saveButtonName = @"下一步";
    
}
-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initData{
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonSystemItemAction target:self action:@selector(backTo)];
    
    NSString *url;
    if (self.taskid>0)
        url =  [NSString stringWithFormat:@"api/add_inscard_step0?userid=%d&taskid=%d",[AppSettings sharedSettings].userid,self.taskid];
    else
        url = [NSString stringWithFormat:@"api/add_inscard_step0?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        id items=@[
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"code",@"label":@"激活码：",@"default":@"",@"placeholder":@"输入激活码",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":@"" }],
                   
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"button",@"label":@"激活卡片",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"OneButtonCell",@"value":@""}]
                   ];
        id items2 =@[[[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"description",@"label":json[@"result"][@"data"],@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"TextLabelCell",@"value":@""}]];
        _list=[NSMutableArray arrayWithArray: @[
               /*@{@"count" : @1,@"list":@[@{@"cell":@"IntroduceCell"}],@"height":@100.0f},*/
               @{@"count" : @2,@"list":items,@"height":@44.0f},
               @{@"count" : @1,@"list":items2,@"height":@300.0f}
               ]];
        [self.tableView reloadData];
    }];
    
    self.title =@"激活卡单";
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section==1){
        return @"激活卡单第一步";
    }else{
        return  Nil;
    }
}
-(void)setupCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    [super setupCell:cell indexPath:indexPath];
}
-(void)processSaving:(NSMutableDictionary *)parameters{
    
    NSString *code = parameters[@"code"];
    
    if([@"" isEqualToString:code]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"请输入激活码！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
    }
    NSString *path =[NSString stringWithFormat:@"api/add_inscard_step1?userid=%d&code=%@",[AppSettings sharedSettings].userid, code];
    
    [[HttpClient sharedHttp] get:path block:^(id json) {
        NSLog(@"%@",json);
        if ([[AppSettings sharedSettings] isSuccess:json]){
            if (json[@"result"][@"data"][@"number"]){
                NSString *number = json[@"result"][@"data"][@"number"];
                AddCardStep2Controller *vc =[[AddCardStep2Controller alloc] initWithStyle:UITableViewStyleGrouped];
                vc.number = number;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }];
}

-(void)buttonPress:(OneButtonCell *)sender{
    [self done];
}

@end
