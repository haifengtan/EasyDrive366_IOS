//
//  NeedPayController.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/7/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "NeedPayController.h"
#import "AppSettings.h"
#import "UIImageView+AFNetworking.h"
#import "NeedPayItemCell.h"
#import "NewOrderController.h"
#import "OrderDetailController.h"
@interface NeedPayController ()<NeedPayItemCellDelegate>{
    id _list;
}

@end

@implementation NeedPayController

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

    [self load_data];
    self.title=@"我的订单";//[self.status isEqualToString:@"finished"]?@"我的订单": @"待付款";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if (![self.status isEqualToString:@"notpay"]){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NeedPayItemCell2" owner:nil options:nil] objectAtIndex:0];
        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NeedPayItemCell" owner:nil options:nil] objectAtIndex:0];
        }
        
    }
    id item = [_list objectAtIndex:indexPath.row];
    NeedPayItemCell *payCell = (NeedPayItemCell *)cell;
    payCell.orderItem = item;
    id product = [item[@"goods"] objectAtIndex:0];
    [payCell.imagePicture setImageWithURL:[NSURL URLWithString:product[@"pic_url"]]];
    payCell.lblName.text = product[@"name"];
    payCell.lblDescription.text = product[@"description"];
    payCell.lblPrice.text= item[@"order_total"];
    payCell.lblQuantity.text = product[@"quantity"];
    payCell.delegate = self;
    if (![self.status isEqualToString:@"notpay"]){
        payCell.lblTime.text = item[@"order_time"];
        payCell.lblOrder_id.text = item[@"po"];
        payCell.lblStatus.text = item[@"order_status_name"];
        /*
        [payCell.btnPay removeFromSuperview];
        UILabel *label = [[UILabel alloc] initWithFrame:payCell.btnPay.frame];
        label.text = item[@"order_time"];
        label.font =[UIFont fontWithName:@"Arial" size:10];
        [payCell addSubview:label];
         */
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.0f;
}
-(void)payButtonPressed:(id)orderItem{
    NSLog(@"%@",orderItem);
    NewOrderController *vc = [[NewOrderController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.order_id = orderItem[@"order_id"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)swipeRight:(UITableViewCell *)cell orderItem:(id)orderItem{
    //NSLog(@"%@",cell);
    [cell setEditing:YES];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return  YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete){
        id item = [_list objectAtIndex:indexPath.row];
        NSString *url = [NSString stringWithFormat:@"order/order_del?userid=%d&orderid=%@",[AppSettings sharedSettings].userid,item[@"order_id"]];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                [_list removeObject:item];
                [self.tableView reloadData];
            }
        }];
    }
}
-(void)load_data{
    NSString *url;
    if (self.taskid>0)
        url = [NSString stringWithFormat:@"order/order_list?userid=%d&status=%@&taskid=%d",[AppSettings sharedSettings].userid,self.status,self.taskid];
    else
        url= [NSString stringWithFormat:@"order/order_list?userid=%d&status=%@",[AppSettings sharedSettings].userid,self.status];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _list = json[@"result"];
            [self.tableView reloadData];
        }
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = [_list objectAtIndex:indexPath.row];
    OrderDetailController *vc = [[OrderDetailController alloc] initWithStyle:UITableViewStylePlain];
    vc.order_id=item[@"order_id"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
