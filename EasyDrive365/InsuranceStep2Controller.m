//
//  InsuranceStep2Controller.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/26/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "InsuranceStep2Controller.h"
#import "AppSettings.h"
#import "InsuranceStep3Controller.h"

@interface InsuranceStep2Controller (){
    UIView *ins_view;
    UIView *ins_view2;
    BOOL _sameAsOwner;
    BOOL _sameAsOwner2;
}

@end

@implementation InsuranceStep2Controller

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
    _sameAsOwner=YES;
    _sameAsOwner2=YES;
    
    NSString *url;
    if (self.ins_id){
         self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"投保单" style:UIBarButtonSystemItemAction target:self action:@selector(backTo)];
        url = [NSString stringWithFormat:@"ins/carins_info?userid=%d&id=%@",[AppSettings sharedSettings].userid,self.ins_id];
    }else{
         self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonSystemItemAction target:self action:@selector(backTo)];
        url = [NSString stringWithFormat:@"ins/carins_info?userid=%d&goods_id=%d",[AppSettings sharedSettings].userid,self.goods_id];
    }
    
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        NSString *r_date = json[@"result"][@"registration_date"];
        if ([r_date length]>10){
            r_date = [r_date substringToIndex:10];
        }
        id items=@[
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"car_id",@"label":@"车牌号：",@"default":@"",@"placeholder":@"鲁BFK982",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":json[@"result"][@"car_id"] }],
                   
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"vin",@"label":@"VIN：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":json[@"result"][@"vin"] }],
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"engine_no",@"label":@"发动机号：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":json[@"result"][@"engine_no"] }],
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"registration_date",@"label":@"  初登日期：",@"default":@"",@"placeholder":@"DatePickerViewController",@"ispassword":@"no",@"cell":@"ChooseNextCell",@"value":r_date }],
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"owner_name",@"label":@"车主姓名：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":json[@"result"][@"owner_name"] }],
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"owner_license",@"label":@"证件号码：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":json[@"result"][@"owner_license"] }],
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"owner_phone",@"label":@"手机号：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":json[@"result"][@"owner_phone"] }]
                   
                   ];
        id items2=@[[[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"policy_hoder",@"label":@"投保人：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":json[@"result"][@"policy_hoder"] }],
                    [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"policy_hoder_license",@"label":@"证件号码：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":json[@"result"][@"policy_hoder_license"] }]
                    ];
        id items3=@[
                    [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"name",@"label":@"姓名：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":json[@"result"][@"name"] }],
                    [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"license_id",@"label":@"证件号码：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":json[@"result"][@"license_id"] }],
                    [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"phone",@"label":@"手机号：",@"default":@"",@"placeholder":@"",@"ispassword":@"number",@"cell":@"EditTextCell",@"value":json[@"result"][@"phone"] }]
                    ];
        _list=[NSMutableArray arrayWithArray: @[

                                                @{@"count" : @7,@"list":items,@"height":@44.0f},
                                                @{@"count" : @2,@"list":items2,@"height":@44.0f},
                                                @{@"count" : @3,@"list":items3,@"height":@44.0f}
                                                ]];
        [self.tableView reloadData];
    }];
    
    self.title = @"第二步";
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0)
        return @"车辆基本信息";
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
            label.text =@"被保险人信息";
            [ins_view addSubview:label];
            UILabel *label2 =[[UILabel alloc] initWithFrame:CGRectMake(180, 10, 60, 21)];
            label2.font =[UIFont fontWithName:@"Arial" size:14.0f];
            [label2 setTextAlignment:NSTextAlignmentRight];
            label2.text =@"同车主";
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
            label.text =@"投保人信息";
            [ins_view2 addSubview:label];
            UILabel *label2 =[[UILabel alloc] initWithFrame:CGRectMake(180, 10, 60, 21)];
            label2.font =[UIFont fontWithName:@"Arial" size:14.0f];
            [label2 setTextAlignment:NSTextAlignmentRight];
            label2.text =@"同车主";
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
-(void)valueChanged:(NSString *)key value:(NSString *)value{
    NSLog(@"%@=%@",key,value);
    if (_sameAsOwner){
        if ([key isEqualToString:@"owner_name"]){
            [[_list objectAtIndex:2][@"list"] objectAtIndex:0][@"value"]=value;

            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        if ([key isEqualToString:@"owner_license"]){
            [[_list objectAtIndex:2][@"list"] objectAtIndex:1][@"value"]=value;

            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        }
        if ([key isEqualToString:@"owner_phone"]){
            [[_list objectAtIndex:2][@"list"] objectAtIndex:2][@"value"]=value;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:2];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        }
        
        
    }
    if (_sameAsOwner2){
        if ([key isEqualToString:@"owner_name"]){

            [[_list objectAtIndex:1][@"list"] objectAtIndex:0][@"value"]=value;

            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        if ([key isEqualToString:@"owner_license"]){

            [[_list objectAtIndex:1][@"list"] objectAtIndex:1][@"value"]=value;

            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        
        
    }
}
-(void)sameAsOwner:(UISwitch *)sw{
    _sameAsOwner = sw.isOn;
    if (sw.isOn){
        
        [[_list objectAtIndex:2][@"list"] objectAtIndex:0][@"value"]=[[_list objectAtIndex:0][@"list"] objectAtIndex:4][@"value"];
        [[_list objectAtIndex:2][@"list"] objectAtIndex:1][@"value"]=[[_list objectAtIndex:0][@"list"] objectAtIndex:5][@"value"];
         [[_list objectAtIndex:2][@"list"] objectAtIndex:2][@"value"]=[[_list objectAtIndex:0][@"list"] objectAtIndex:6][@"value"];
        [self.tableView reloadData];
    }
}
-(void)sameAsOwner2:(UISwitch *)sw{
    _sameAsOwner2 = sw.isOn;
    if (sw.isOn){
        
        [[_list objectAtIndex:1][@"list"] objectAtIndex:0][@"value"]=[[_list objectAtIndex:0][@"list"] objectAtIndex:4][@"value"];
        [[_list objectAtIndex:1][@"list"] objectAtIndex:1][@"value"]=[[_list objectAtIndex:0][@"list"] objectAtIndex:5][@"value"];

        [self.tableView reloadData];
    }
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
         [[[UIAlertView alloc] initWithTitle:AppTitle message:@"VIN不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
         return;
        
    }
    NSString *engine_no=[parameters objectForKey:@"engine_no"];
    if([@"" isEqualToString:engine_no]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"发动机号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *registration_date=[parameters objectForKey:@"registration_date"];
    if([@"" isEqualToString:registration_date]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"初登日期不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *owner_name=[parameters objectForKey:@"owner_name"];
    if([@"" isEqualToString:owner_name]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"车主姓名不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    //owner_license
    NSString *owner_license=[parameters objectForKey:@"owner_license"];
    if([@"" isEqualToString:owner_license]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"车主－证件号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }else{
        /*
        if ([owner_license length]!=18){
            [[[UIAlertView alloc] initWithTitle:@"易驾366" message:@"车主－身份证号码必须18位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            return;
        }
        NSString *temp =[owner_license stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
        NSLog(@"%@=%d",temp,[temp length]);
        if (([temp length]==0) || (([temp length]==1) && ([owner_license hasSuffix:@"X"]))){
            
            
        }else{
            [[[UIAlertView alloc] initWithTitle:@"易驾366" message:@"车主－身份证号码必须18位,只有最后一位允许是X" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            return;
        }
        */
        
    }
    //owner_phone
    NSString *owner_phone=[parameters objectForKey:@"owner_phone"];
    if([@"" isEqualToString:owner_phone]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"车主手机号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    //policy_hoder
    NSString *policy_hoder=[parameters objectForKey:@"policy_hoder"];
    if([@"" isEqualToString:policy_hoder]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"投保人不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *policy_hoder_license=[parameters objectForKey:@"policy_hoder_license"];
    if([@"" isEqualToString:policy_hoder_license]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"投保人证件号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *name=[parameters objectForKey:@"name"];
    if([@"" isEqualToString:name]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"被保险人姓名不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    
    NSString *license_id = [parameters objectForKey:@"license_id"];
    if([@"" isEqualToString:license_id]){
        
         [[[UIAlertView alloc] initWithTitle:@"提示" message:@"被保险人－证件号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续", nil] show];
         return;
        
    }else{
        /*
        if ([license_id length]!=18){
            [[[UIAlertView alloc] initWithTitle:@"易驾366" message:@"被保险人－身份证号码必须18位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            return;
        }
        NSString *temp =[license_id stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
        //NSLog(@"%@=%d",temp,[temp length]);
        if (([temp length]==0) || (([temp length]==1) && ([license_id hasSuffix:@"X"]))){
            
            
        }else{
            [[[UIAlertView alloc] initWithTitle:@"易驾366" message:@"被保险人－身份证号码必须18位,只有最后一位允许是X" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            return;
        }
         */
    }
    NSString *phone=[parameters objectForKey:@"phone"];
    if([@"" isEqualToString:phone]){
         [[[UIAlertView alloc] initWithTitle:AppTitle message:@"被保险人－手机号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
         return;
        
    }
    
    
    
    
    NSString *path =[NSString stringWithFormat:@"ins/carins_confirm?userid=%d&car_id=%@&vin=%@&engine_no=%@&registration_date=%@&owner_name=%@&name=%@&license_id=%@&phone=%@&owner_license=%@&owner_phone=%@&policy_hoder=%@&policy_hoder_license=%@",[AppSettings sharedSettings].userid, car_id,vin,engine_no,registration_date,owner_name,name,license_id,phone,
                     owner_license,owner_phone,policy_hoder,policy_hoder_license];
    
    [[HttpClient sharedHttp] get:path block:^(id json) {
        NSLog(@"%@",json);
        if ([[AppSettings sharedSettings] isSuccess:json]){
            InsuranceStep3Controller *vc = [[InsuranceStep3Controller alloc] initWithStyle:UITableViewStyleGrouped];
            vc.car_data = json[@"result"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}
@end
