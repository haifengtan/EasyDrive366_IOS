//
//  InsuranceStep3Controller.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/26/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "InsuranceStep3Controller.h"
#import "InsuranceStep4Controller.h"
#import "AppSettings.h"
#import "BrandSelectController.h"

@interface InsuranceStep3Controller (){
    id _brand_items;
    id _brand_selected;
}

@end

@implementation InsuranceStep3Controller

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(brand_selected:) name:SELECTED_BRAND object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)init_setup{
    _saveButtonName = @"下一步";
    
}
-(void)brand_selected:(NSNotification *)sender{
    _brand_selected = [sender userInfo];
    NSLog(@"%@",_brand_selected);
    [[_list objectAtIndex:0][@"list"] objectAtIndex:0][@"value"] = _brand_selected[@"brand"];
//    self.car_data[@"brand_id"]=_brand_selected[@"brand_id"];
    [[_list objectAtIndex:0][@"list"] objectAtIndex:1][@"value"]=_brand_selected[@"model"];
    [[_list objectAtIndex:0][@"list"] objectAtIndex:2][@"value"]=_brand_selected[@"exhause"];
    [[_list objectAtIndex:0][@"list"] objectAtIndex:3][@"value"]=_brand_selected[@"passengers"];
    [[_list objectAtIndex:0][@"list"] objectAtIndex:4][@"value"]=_brand_selected[@"price"];
    [self.tableView reloadData];
}
-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initData{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonSystemItemAction target:self action:@selector(backTo)];
    
    id items=@[
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"brand",@"label":@"品牌型号：",@"default":@"",@"placeholder":@"BrandSelectController",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":self.car_data[@"brand"],@"has_choice":@"1" }],
               
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"model",@"label":@"车款：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":self.car_data[@"model"],@"disable":@"1"}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"exhause",@"label":@"排气量：",@"default":@"",@"placeholder":@"",@"ispassword":@"decimal",@"cell":@"EditTextCell",@"value":self.car_data[@"exhause"] }],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"passengers",@"label":@"乘客数：",@"default":@"",@"placeholder":@"DatePickerViewController",@"ispassword":@"number",@"cell":@"EditTextCell",@"value":self.car_data[@"passengers"] }],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"price",@"label":@"参考价格：",@"default":@"",@"placeholder":@"",@"ispassword":@"decimal",@"cell":@"EditTextCell",@"value":self.car_data[@"price"] }]
               ];
    id items2=@[
                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"biz_valid",@"label":@"商业险起期：",@"default":@"",@"placeholder":@"DatePickerViewController",@"ispassword":@"no",@"cell":@"ChooseNextCell",@"value":self.car_data[@"biz_valid"] }],
                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"com_valid",@"label":@"交强险起期：",@"default":@"",@"placeholder":@"DatePickerViewController",@"ispassword":@"no",@"cell":@"ChooseNextCell",@"value":self.car_data[@"com_valid"] }]
                ];
    _list=[NSMutableArray arrayWithArray: @[
                                            
                                            @{@"count" : @5,@"list":items,@"height":@44.0f},
                                            @{@"count" : @2,@"list":items2,@"height":@44.0f}
                                            ]];
    _brand_items = self.car_data[@"list"];
   
    [self.tableView reloadData];
    
    self.title = @"第三步";
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0)
        return @"车辆基本信息-确认";
    else
        return @"上年保险";
}
-(void)setupCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    [super setupCell:cell indexPath:indexPath];
}
-(void)processSaving:(NSMutableDictionary *)parameters{
    NSLog(@"%@",parameters);
    NSString *price =[parameters objectForKey:@"price"];
    if([@"" isEqualToString:price]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"参考价格不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    
    NSString *biz_valid=[parameters objectForKey:@"biz_valid"];
    if([@"" isEqualToString:biz_valid]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"商业险起期不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *com_valid=[parameters objectForKey:@"com_valid"];
    if([@"" isEqualToString:com_valid]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"交强险起期不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
   
    
    NSString *b_id =_brand_selected?_brand_selected[@"brand_id"]:self.car_data[@"brand_id"];
    NSString *b =[parameters objectForKey:@"brand"];
    
    NSString *path =[NSString stringWithFormat:@"ins/carins_clause?userid=%d&biz_valid=%@&com_valid=%@&price=%@&brand_id=%@&brand=%@",[AppSettings sharedSettings].userid,biz_valid,com_valid,price,b_id,b];
    
    [[HttpClient sharedHttp] get:path block:^(id json) {
        NSLog(@"%@",json);
        if ([[AppSettings sharedSettings] isSuccess:json]){
            InsuranceStep4Controller *vc = [[InsuranceStep4Controller alloc] initWithStyle:UITableViewStyleGrouped];
            vc.insurance_data = json[@"result"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item  = [[_list objectAtIndex:indexPath.section][@"list"] objectAtIndex:indexPath.row];
    if ([item[@"cell"] isEqualToString:@"EditTextCell"]){
        NSString *vcname = item[@"placeholder"];

        if ([vcname isEqualToString:@"BrandSelectController"]){
            BrandSelectController *vc =[[BrandSelectController alloc] initWithStyle:UITableViewStylePlain];
            vc.list = _brand_items;
            vc.brand_id = self.car_data[@"brand_id"];
            vc.brand = self.car_data[@"brand"];
            [self.navigationController pushViewController:vc animated:YES];
            [self performSelector:@selector(delectCell:) withObject:nil afterDelay:0.2];
            return;
        }
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}
@end
