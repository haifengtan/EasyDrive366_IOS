//
//  OrderConfirmationViewController.m
//  EasyDrive366
//
//  Created by admin on 14-8-6.
//  Copyright (c) 2014年 Fu Steven. All rights reserved.
//

#import "OrderConfirmationViewController.h"
#import "AppSettings.h"
#import "OrderFinishedController.h"

@interface OrderConfirmationViewController (){
    UIView *ins_view;
    UIView *ins_view2;
}

@end

@implementation OrderConfirmationViewController
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
    _saveButtonName = @"确定投保";
    
}
-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initData{

    //被保险人信息
    id items=@[
               //被保险人姓名
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"insured_name",@"label":@"姓名：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":[_order_info objectForKey:@"insured_name"],@"disable":@"1"}],
               //被保险人证件类型
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"insured_card_type",@"label":@"证件类型：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":[_order_info objectForKey:@"insured_card_type"],@"disable":@"1"}],
               //被保险人证件号码
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"insured_idcard",@"label":@"证件号码：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":[_order_info objectForKey:@"insured_idcard"],@"disable":@"1"}],
               //被保险人职业类别
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"insured_career_type",@"label":@"职业类别：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":[_order_info objectForKey:@"insured_career_type"],@"disable":@"1"}],
               //被保险人联系电话
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"insured_phone",@"label":@"联系电话：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":[_order_info objectForKey:@"insured_phone"],@"disable":@"1"}],
               //被保险人地址
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"insured_address",@"label":@"地址：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":[_order_info objectForKey:@"insured_address"],@"disable":@"1"}]
               
               ];
    
    //受益人信息
    id items2=@[
                //受益人姓名
                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"beneficiary_name",@"label":@"姓名：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":[_order_info objectForKey:@"beneficiary_name"],@"disable":@"1"}],
                //受益人证件类型
                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"beneficiary_card_type",@"label":@"证件类型：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":[_order_info objectForKey:@"beneficiary_card_type"],@"disable":@"1"}],
                //收益人证件号码
                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"beneficiary_idcard",@"label":@"证件号码：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":[_order_info objectForKey:@"beneficiary_idcard"],@"disable":@"1"}],
                //收益人联系电话
                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"beneficiary_phone",@"label":@"联系电话：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":[_order_info objectForKey:@"insured_name"],@"disable":@"1"}],
                //收益人地址
                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"beneficiary_address",@"label":@"地址：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":[_order_info objectForKey:@"beneficiary_address"],@"disable":@"1"}]
                ];
    
    //投保人信息
    id items3=@[
                //投保人姓名
                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"policy_holder_name",@"label":@"姓名：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":[_order_info objectForKey:@"policy_holder_name"],@"disable":@"1"}],
                //投保人证件类型
                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"policy_holder_card_type",@"label":@"证件类型：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":[_order_info objectForKey:@"policy_holder_card_type"] ,@"disable":@"1"}],
                //投保人证件号码
                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"policy_holder_idcard",@"label":@"证件号码：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":[_order_info objectForKey:@"policy_holder_idcard"],@"disable":@"1"}],
                //投保人联系电话
                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"policy_holder_phone",@"label":@"联系电话：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":[_order_info objectForKey:@"policy_holder_phone"],@"disable":@"1"}],
                //投保人地址
                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"policy_holder_address",@"label":@"地址：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":[_order_info objectForKey:@"policy_holder_address"],@"disable":@"1"}],
                ];
    
    _list=[NSMutableArray arrayWithArray: @[
                                            @{@"count" : @6,@"list":items,@"height":@44.0f},
                                            @{@"count" : @5,@"list":items2,@"height":@44.0f},
                                            @{@"count" : @5,@"list":items3,@"height":@44.0f}
                                            ]];
    [self.tableView reloadData];
    
    self.title = @"信息确认";
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0)
        return @"被保险人信息";
    else
        return @"被保险人信息";
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0){
        return nil;
    }else if (section==2){
        if (!ins_view){
            ins_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
            UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 160, 21)];
            label.font =[UIFont fontWithName:@"Arial" size:14.0f];
            label.text =@"投保人信息";
            [ins_view addSubview:label];
            
        }
        return  ins_view;
        
    }else if (section==1){
        if (!ins_view2){
            ins_view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
            UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 160, 21)];
            label.font =[UIFont fontWithName:@"Arial" size:14.0f];
            label.text =@"受益人信息";
            [ins_view2 addSubview:label];
            
        }
        return  ins_view2;
        
    }
    return nil;
    
}

-(void)setupCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    [super setupCell:cell indexPath:indexPath];
}
-(void)processSaving:(NSMutableDictionary *)parameters{
    
//    //验证被保险人信息
//    NSString *insured_name=[parameters objectForKey:@"insured_name"];
//    if([@"" isEqualToString:insured_name]){
//        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"被保险人姓名不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
//        return;
//        
//    }
//    NSString *insured_card_type=[parameters objectForKey:@"insured_card_type"];
//    if([@"" isEqualToString:insured_card_type]){
//        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"被保险人证件类型不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
//        return;
//        
//    }
//    NSString *insured_idcard=[parameters objectForKey:@"insured_idcard"];
//    if([@"" isEqualToString:insured_idcard]){
//        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"被保险人证件号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
//        return;
//        
//    }
//    NSString *insured_career_type=[parameters objectForKey:@"insured_career_type"];
//    if([@"" isEqualToString:insured_career_type]){
//        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"被保险人职业类别不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
//        return;
//        
//    }
//    NSString *insured_phone=[parameters objectForKey:@"insured_phone"];
//    if([@"" isEqualToString:insured_phone]){
//        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"被保险人联系方式不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
//        return;
//        
//    }
//    NSString *insured_address=[parameters objectForKey:@"insured_address"];
//    if([@"" isEqualToString:insured_address]){
//        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"被保险人地址不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
//        return;
//        
//    }
//    
//    //验证受益人信息
//    NSString *beneficiary_name=[parameters objectForKey:@"beneficiary_name"];
//    if([@"" isEqualToString:beneficiary_name]){
//        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"受益人姓名不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
//        return;
//        
//    }
//    NSString *beneficiary_card_type=[parameters objectForKey:@"beneficiary_card_type"];
//    if([@"" isEqualToString:beneficiary_card_type]){
//        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"受益人证件类型不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
//        return;
//        
//    }
//    NSString *beneficiary_idcard=[parameters objectForKey:@"beneficiary_idcard"];
//    if([@"" isEqualToString:beneficiary_idcard]){
//        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"受益人证件号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
//        return;
//        
//    }
//    NSString *beneficiary_phone=[parameters objectForKey:@"beneficiary_phone"];
//    if([@"" isEqualToString:beneficiary_phone]){
//        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"受益人联系方式不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
//        return;
//        
//    }
//    NSString *beneficiary_address=[parameters objectForKey:@"beneficiary_address"];
//    if([@"" isEqualToString:beneficiary_address]){
//        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"受益人地址不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
//        return;
//        
//    }
//    
//    //验证投保人信息
//    NSString *policy_holder_name=[parameters objectForKey:@"policy_holder_name"];
//    if([@"" isEqualToString:policy_holder_name]){
//        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"投保人姓名不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
//        return;
//        
//    }
//    NSString *policy_holder_card_type=[parameters objectForKey:@"policy_holder_card_type"];
//    if([@"" isEqualToString:policy_holder_card_type]){
//        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"投保人证件类型不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
//        return;
//        
//    }
//    NSString *policy_holder_idcard=[parameters objectForKey:@"policy_holder_idcard"];
//    if([@"" isEqualToString:policy_holder_idcard]){
//        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"投保人证件号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
//        return;
//        
//    }
//    NSString *policy_holder_phone=[parameters objectForKey:@"policy_holder_phone"];
//    if([@"" isEqualToString:policy_holder_phone]){
//        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"投保人联系方式不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
//        return;
//        
//    }
//    NSString *policy_holder_address=[parameters objectForKey:@"policy_holder_address"];
//    if([@"" isEqualToString:policy_holder_address]){
//        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"投保人地址不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
//        return;
//        
//    }
    
//    NSString *url =[NSString stringWithFormat:@"order/order_ins_related_submit?userid=%d&orderid=%@&policy_holder_name=%@&policy_holder_card_type=%@&policy_holder_idcard=%@&policy_holder_phone=%@&policy_holder_address=%@&beneficiary_name=%@&beneficiary_card_type=%@&beneficiary_idcard=%@&beneficiary_phone=%@&beneficiary_address=%@&insured_name=%@&insured_card_type=%@&insured_idcard=%@&insured_phone=%@&insured_address=%@&insured_career_type=%@",[AppSettings sharedSettings].userid, _order_id,policy_holder_name,policy_holder_card_type,policy_holder_idcard,policy_holder_phone,policy_holder_address,beneficiary_name,beneficiary_card_type,
//                    beneficiary_idcard,beneficiary_phone,beneficiary_address,insured_name,insured_card_type,insured_idcard,insured_phone,insured_address,insured_career_type];
    
    NSString *url =[NSString stringWithFormat:@"order/policyIssuing?orderid=%@", _order_id];
    [[HttpClient sharedHttp] get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            OrderFinishedController *vc = [[OrderFinishedController alloc] initWithNibName:@"OrderFinishedController" bundle:Nil];
            vc.content_data = json[@"result"];
            [self.navigationController pushViewController:vc animated:YES];

        }
    }];
}
@end