//
//  OrderContentController.m
//  EasyDrive366
//
//  Created by Steven Fu on 2/19/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "OrderContentController2.h"
#import "AppSettings.h"
#import "OrderFinishedController.h"
#import "OrderConfirmationViewController.h"

@interface OrderContentController2 (){
    UIView *ins_view;
    UIView *ins_view2;
    BOOL _sameAsOwner;
    BOOL _sameAsOwner2;
    //职业类别编号
     int _job_id;
    //被保险人证件类型编号
    NSString* insured_card_type_number;
    //受益人证件类型编号
    NSString* beneficiary_card_type_number;
    //投保人证件类型编号
    NSString* policy_holder_card_type_number;
    
}

@end

@implementation OrderContentController2

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
      [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(selected_job2:) name:SELECTED_JOBITEM object:nil];
	// Do any additional setup after loading the view.
}

-(void)selected_job2:(NSNotification *)notification{
    _job_id = [notification.userInfo[@"id"] intValue];
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
    _sameAsOwner=YES;
    _sameAsOwner2=YES;
    //职业类别
    _job_id=_ins_data[@"job_id"];
    //被保险人信息
    id items=@[
               //被保险人姓名
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"insured_name",@"label":@"姓名：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":_ins_data[@"insured_name"]}],
               //被保险人证件类型
//               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"insured_card_type",@"label":@"证件类型：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":_ins_data[@"insured_card_type"]}],
               
                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"insured_card_type",@"label":@"证件类型：",@"default":@"",@"placeholder":@"CardTypeViewController",@"ispassword":@"no",@"cell":@"ChooseNextCell",@"value":_ins_data[@"insured_card_type"]}],
               
               //被保险人证件号码
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"insured_idcard",@"label":@"证件号码：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":_ins_data[@"insured_idcard"]}],
               //被保险人职业类别
//               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"insured_career_type",@"label":@"职业类别：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":_ins_data[@"insured_career_type"]}],
               
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"insured_career_type",@"label":@"职业类别：",@"default":@"",@"placeholder":@"JobSelectMainController",@"ispassword":@"no",@"cell":@"ChooseNextCell",@"value":_ins_data[@"insured_career_type"],@"order_id":_ins_data[@"order_id"]}],
               //被保险人联系电话
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"insured_phone",@"label":@"联系电话：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":_ins_data[@"insured_phone"]}],
               //被保险人地址
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"insured_address",@"label":@"地址：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":_ins_data[@"insured_address"]}]
              
               ];
    
    //受益人信息
    id items2=@[
                //受益人姓名
                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"beneficiary_name",@"label":@"姓名：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":_ins_data[@"beneficiary_name"]}],
                //受益人证件类型
//                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"beneficiary_card_type",@"label":@"证件类型：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":_ins_data[@"beneficiary_card_type"]}],
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"beneficiary_card_type",@"label":@"证件类型：",@"default":@"",@"placeholder":@"CardTypeViewController",@"ispassword":@"no",@"cell":@"ChooseNextCell",@"value":_ins_data[@"beneficiary_card_type"]}],
                //收益人证件号码
                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"beneficiary_idcard",@"label":@"证件号码：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":_ins_data[@"beneficiary_idcard"]}],
                //收益人联系电话
                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"beneficiary_phone",@"label":@"联系电话：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":_ins_data[@"beneficiary_phone"]}],
                //收益人地址
                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"beneficiary_address",@"label":@"地址：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":_ins_data[@"beneficiary_address"]}]
                                         ];
    
    //投保人信息
    id items3=@[
                //投保人姓名
                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"policy_holder_name",@"label":@"姓名：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":_ins_data[@"policy_holder_name"]}],
                //投保人证件类型
//                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"policy_holder_card_type",@"label":@"证件类型：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":_ins_data[@"policy_holder_card_type"]}],
                 [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"policy_holder_card_type",@"label":@"证件类型：",@"default":@"",@"placeholder":@"CardTypeViewController",@"ispassword":@"no",@"cell":@"ChooseNextCell",@"value":_ins_data[@"policy_holder_card_type"]}],
                //投保人证件号码
                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"policy_holder_idcard",@"label":@"证件号码：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":_ins_data[@"policy_holder_idcard"]}],
                //投保人联系电话
                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"policy_holder_phone",@"label":@"联系电话：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":_ins_data[@"policy_holder_phone"]}],
                //投保人地址
                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"policy_holder_address",@"label":@"地址：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":_ins_data[@"policy_holder_address"]}]
                ];
    
    _list=[NSMutableArray arrayWithArray: @[
                                            @{@"count" : @6,@"list":items,@"height":@44.0f},
                                            @{@"count" : @5,@"list":items2,@"height":@44.0f},
                                            @{@"count" : @5,@"list":items3,@"height":@44.0f}
                                            ]];
    [self.tableView reloadData];
    
    self.title = @"保险信息";
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
            UILabel *label2 =[[UILabel alloc] initWithFrame:CGRectMake(170, 10, 70, 21)];
            label2.font =[UIFont fontWithName:@"Arial" size:14.0f];
            [label2 setTextAlignment:NSTextAlignmentRight];
            label2.text =@"同被保险人";
            [ins_view addSubview:label2];
            UISwitch *sw =[[UISwitch alloc] initWithFrame:CGRectMake(240, 5, 60, 21)];
            [sw addTarget:self action:@selector(sameAsOwner:) forControlEvents:UIControlEventValueChanged];
            sw.on = _sameAsOwner;
            [ins_view addSubview:sw];
            
        }
        return  ins_view;
        
    }else if (section==1){
        if (!ins_view2){
            ins_view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
            UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 160, 21)];
            label.font =[UIFont fontWithName:@"Arial" size:14.0f];
            label.text =@"受益人信息";
            [ins_view2 addSubview:label];
            UILabel *label2 =[[UILabel alloc] initWithFrame:CGRectMake(170, 10, 70, 21)];
            label2.font =[UIFont fontWithName:@"Arial" size:14.0f];
            [label2 setTextAlignment:NSTextAlignmentRight];
            label2.text =@"同被保险人";
            [ins_view2 addSubview:label2];
            UISwitch *sw =[[UISwitch alloc] initWithFrame:CGRectMake(240, 5, 60, 21)];
            [sw addTarget:self action:@selector(sameAsOwner2:) forControlEvents:UIControlEventValueChanged];
            sw.on = _sameAsOwner2;
            [ins_view2 addSubview:sw];
            
        }
        return  ins_view2;
        
    }
    return nil;
    
}

/**
 *  自动修改受益人跟投保人的信息
 *
 *  @param key   <#key description#>
 *  @param value <#value description#>
 */
-(void)valueChanged:(NSString *)key value:(NSString *)value{
    
    /**
     *  投保人信息
     */
    if (_sameAsOwner){
        if ([key isEqualToString:@"insured_name"]){
            [[_list objectAtIndex:2][@"list"] objectAtIndex:0][@"value"]=value;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        if ([key isEqualToString:@"insured_card_type"]){
            [[_list objectAtIndex:2][@"list"] objectAtIndex:1][@"value"]=value;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        if ([key isEqualToString:@"insured_idcard"]){
            [[_list objectAtIndex:2][@"list"] objectAtIndex:2][@"value"]=value;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:2];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        if ([key isEqualToString:@"insured_phone"]){
            [[_list objectAtIndex:2][@"list"] objectAtIndex:3][@"value"]=value;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:2];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        
        if ([key isEqualToString:@"insured_address"]){
            [[_list objectAtIndex:2][@"list"] objectAtIndex:4][@"value"]=value;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:2];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        
        
    }
    
    /**
     *  受益人信息
     */
    if (_sameAsOwner2){
        if ([key isEqualToString:@"insured_name"]){
            [[_list objectAtIndex:1][@"list"] objectAtIndex:0][@"value"]=value;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        if ([key isEqualToString:@"insured_card_type"]){

            [[_list objectAtIndex:1][@"list"] objectAtIndex:1][@"value"]=value;
            
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        
        if ([key isEqualToString:@"insured_idcard"]){
            
            [[_list objectAtIndex:1][@"list"] objectAtIndex:2][@"value"]=value;
            
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        
        if ([key isEqualToString:@"insured_phone"]){
            
            [[_list objectAtIndex:1][@"list"] objectAtIndex:3][@"value"]=value;
            
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        
        if ([key isEqualToString:@"insured_address"]){
            
            [[_list objectAtIndex:1][@"list"] objectAtIndex:4][@"value"]=value;
            
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        
    }
}

/**
 *  投保人 同被保险人 滑块按钮事件
 *
 *  @param sw <#sw description#>
 */
-(void)sameAsOwner:(UISwitch *)sw{
    _sameAsOwner = sw.isOn;
    if (sw.isOn){
        
        [[_list objectAtIndex:2][@"list"] objectAtIndex:0][@"value"]=[[_list objectAtIndex:0][@"list"] objectAtIndex:0][@"value"];
        [[_list objectAtIndex:2][@"list"] objectAtIndex:1][@"value"]=[[_list objectAtIndex:0][@"list"] objectAtIndex:1][@"value"];
        [[_list objectAtIndex:2][@"list"] objectAtIndex:2][@"value"]=[[_list objectAtIndex:0][@"list"] objectAtIndex:2][@"value"];
         [[_list objectAtIndex:2][@"list"] objectAtIndex:3][@"value"]=[[_list objectAtIndex:0][@"list"] objectAtIndex:4][@"value"];
         [[_list objectAtIndex:2][@"list"] objectAtIndex:4][@"value"]=[[_list objectAtIndex:0][@"list"] objectAtIndex:5][@"value"];
        [self.tableView reloadData];
    }
}

/**
 *  受益人信息  同被保险人 滑块按钮事件
 *
 *  @param sw <#sw description#>
 */
-(void)sameAsOwner2:(UISwitch *)sw{
    _sameAsOwner2 = sw.isOn;
    if (sw.isOn){
        
        [[_list objectAtIndex:1][@"list"] objectAtIndex:0][@"value"]=[[_list objectAtIndex:0][@"list"] objectAtIndex:0][@"value"];
        [[_list objectAtIndex:1][@"list"] objectAtIndex:1][@"value"]=[[_list objectAtIndex:0][@"list"] objectAtIndex:1][@"value"];
        [[_list objectAtIndex:1][@"list"] objectAtIndex:2][@"value"]=[[_list objectAtIndex:0][@"list"] objectAtIndex:2][@"value"];
        [[_list objectAtIndex:1][@"list"] objectAtIndex:3][@"value"]=[[_list objectAtIndex:0][@"list"] objectAtIndex:4][@"value"];
        [[_list objectAtIndex:1][@"list"] objectAtIndex:4][@"value"]=[[_list objectAtIndex:0][@"list"] objectAtIndex:5][@"value"];
        [self.tableView reloadData];
    }
}

-(void)setupCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    [super setupCell:cell indexPath:indexPath];
}
-(void)processSaving:(NSMutableDictionary *)parameters{
    NSLog(@"%@",parameters);

    //验证被保险人信息
    NSString *insured_name=[parameters objectForKey:@"insured_name"];
    if([@"" isEqualToString:insured_name]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"被保险人姓名不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *insured_card_type=[parameters objectForKey:@"insured_card_type"];
    if([@"" isEqualToString:insured_card_type]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"被保险人证件类型不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *insured_idcard=[parameters objectForKey:@"insured_idcard"];
    if([@"" isEqualToString:insured_idcard]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"被保险人证件号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *insured_career_type=[parameters objectForKey:@"insured_career_type"];
    if([@"" isEqualToString:insured_career_type]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"被保险人职业类别不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *insured_phone=[parameters objectForKey:@"insured_phone"];
    if([@"" isEqualToString:insured_phone]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"被保险人联系方式不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *insured_address=[parameters objectForKey:@"insured_address"];
    if([@"" isEqualToString:insured_address]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"被保险人地址不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }

    //验证受益人信息
    NSString *beneficiary_name=[parameters objectForKey:@"beneficiary_name"];
    if([@"" isEqualToString:beneficiary_name]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"受益人姓名不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *beneficiary_card_type=[parameters objectForKey:@"beneficiary_card_type"];
    if([@"" isEqualToString:beneficiary_card_type]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"受益人证件类型不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *beneficiary_idcard=[parameters objectForKey:@"beneficiary_idcard"];
    if([@"" isEqualToString:beneficiary_idcard]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"受益人证件号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *beneficiary_phone=[parameters objectForKey:@"beneficiary_phone"];
    if([@"" isEqualToString:beneficiary_phone]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"受益人联系方式不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *beneficiary_address=[parameters objectForKey:@"beneficiary_address"];
    if([@"" isEqualToString:beneficiary_address]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"受益人地址不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    
    //验证投保人信息
    NSString *policy_holder_name=[parameters objectForKey:@"policy_holder_name"];
    if([@"" isEqualToString:policy_holder_name]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"投保人姓名不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *policy_holder_card_type=[parameters objectForKey:@"policy_holder_card_type"];
    if([@"" isEqualToString:policy_holder_card_type]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"投保人证件类型不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *policy_holder_idcard=[parameters objectForKey:@"policy_holder_idcard"];
    if([@"" isEqualToString:policy_holder_idcard]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"投保人证件号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *policy_holder_phone=[parameters objectForKey:@"policy_holder_phone"];
    if([@"" isEqualToString:policy_holder_phone]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"投保人联系方式不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *policy_holder_address=[parameters objectForKey:@"policy_holder_address"];
    if([@"" isEqualToString:policy_holder_address]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"投保人地址不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    _order_id=_ins_data[@"order_id"];
    //跳转到信息确认页面
//    OrderConfirmationViewController *vc = [[OrderConfirmationViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    vc.order_info =parameters;
//    vc.order_id=_order_id;
//    [self.navigationController pushViewController:vc animated:YES];
    
//    NSString* insured_card_type_number;
//    //受益人证件类型编号
//    NSString* beneficiary_card_type_number;
//    //投保人证件类型编号
//    NSString* policy_holder_card_type;
//
    if ([policy_holder_card_type isEqualToString:@"身份证"]) {
        policy_holder_card_type_number =@"01";
    }else{
        policy_holder_card_type_number =@"02";
    }
    
    if ([beneficiary_card_type isEqualToString:@"身份证"]) {
        beneficiary_card_type_number =@"01";
    }else{
        beneficiary_card_type_number =@"02";
    }
    
    if ([insured_card_type isEqualToString:@"身份证"]) {
        insured_card_type_number =@"01";
    }else{
        insured_card_type_number =@"02";
    }
    
    NSString *url =[NSString stringWithFormat:@"order/order_ins_related_submit?userid=%d&orderid=%@&policy_holder_name=%@&policy_holder_card_type=%@&policy_holder_idcard=%@&policy_holder_phone=%@&policy_holder_address=%@&beneficiary_name=%@&beneficiary_card_type=%@&beneficiary_idcard=%@&beneficiary_phone=%@&beneficiary_address=%@&insured_name=%@&insured_card_type=%@&insured_idcard=%@&insured_phone=%@&insured_address=%@&insured_career_type=%@&insured_card_type_number=%@&beneficiary_card_type_number=%@&policy_holder_card_type_number=%@&job_id=%d",[AppSettings sharedSettings].userid, _order_id,policy_holder_name,policy_holder_card_type,policy_holder_idcard,policy_holder_phone,policy_holder_address,beneficiary_name,beneficiary_card_type,
                     beneficiary_idcard,beneficiary_phone,beneficiary_address,insured_name,insured_card_type,insured_idcard,insured_phone,insured_address,insured_career_type,insured_card_type_number,beneficiary_card_type_number,policy_holder_card_type_number,_job_id];
    
    [[HttpClient sharedHttp] get:url block:^(id json) {
        NSLog(@"%@",json);
             if ([[AppSettings sharedSettings] isSuccess:json]){
                    OrderConfirmationViewController *vc = [[OrderConfirmationViewController alloc] initWithStyle:UITableViewStyleGrouped];
//                    vc.car_data = json[@"result"];
                 vc.order_info =parameters;
                 vc.order_id=_order_id;
                    [self.navigationController pushViewController:vc animated:YES];
             }
    }];
}
@end
