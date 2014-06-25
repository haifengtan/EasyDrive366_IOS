//
//  OrderDetailController.m
//  EasyDrive366
//  订单详情页面
//  Created by Steven Fu on 1/8/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "OrderDetailController.h"
#import "BuyButtonView.h"
#import "OrderProductCell.h"
#import "AppSettings.h"
#import "UIImageView+AFNetworking.h"
#import "NewOrderController.h"
#import "AfterPayController.h"
#import "UploadPhotoController.h"
#import "Browser2Controller.h"
#import "BoundListController.h"
#import "GoodsDetailController.h"
@interface OrderDetailController ()<BuyButtonViewDelegate>{
    id _list;
    id _sectionList;
    NSString *_order_status;
    NSString *_order_status_name;
    BuyButtonView *_buttonView;
    NSString *_next_form;
    int _is_exform;
    int _footer_index;
    int _is_upload;
    NSString *order_url;
}

@end

@implementation OrderDetailController

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

    self.title = @"订单详情";
    [self load_data];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [_list count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_list objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    id item = [[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (item[@"pic_url"]){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderProductCell" owner:nil options:nil] objectAtIndex:0];
        OrderProductCell *productCell = (OrderProductCell *)cell;
        [productCell.imageProduct setImageWithURL:[NSURL URLWithString:item[@"pic_url"]]];
        productCell.lblName.text= item[@"name"];
        productCell.lblDescription.text = item[@"description"];
        productCell.lblPrice.text = item[@"price"];
        productCell.lblStand_price.text = item[@"stand_price"];
        productCell.lblStand_price.strikeThroughEnabled = YES;
        productCell.lblDiscount.text = item[@"discount"];
        productCell.lblBuyer.text = item[@"buyer"];
        productCell.lblStatus.text =@"";// _order_status_name;
    }else{
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.textLabel.text = item[@"title"];
        cell.detailTextLabel.text = item[@"detail"];
        cell.detailTextLabel.font =[UIFont fontWithName:@"Arial" size:12];
        if (item[@"key"]){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (item[@"url"] && ![item[@"url"] isEqualToString:@""]){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        if (item[@"lines"]){
            cell.detailTextLabel.numberOfLines = [item[@"lines"] intValue];
        }
    }
    
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = [[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (item[@"pic_url"]){
        return 120.0f;
    }else if (item[@"height"]){
        return [item[@"height"] floatValue];
    }else{
        return 44.0f;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_sectionList objectAtIndex:section];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ([_order_status isEqualToString:@"notpay"] &&  section==_footer_index){
        if (!_buttonView){
            _buttonView = [[[NSBundle mainBundle] loadNibNamed:@"BuyButtonView" owner:nil options:nil] objectAtIndex:0];
            _buttonView.delegate = self;
            [_buttonView.btnBuy setBackgroundImage:[UIImage imageNamed:@"btnpay_big"] forState:UIControlStateNormal];
        }
        return _buttonView;
    }
    return  nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([_order_status isEqualToString:@"notpay"] &&  section==_footer_index){
        return 80.0f;
    }
    return  22.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = [[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (item[@"key"] && [item[@"key"] isEqualToString:@"upload"]){
        UploadPhotoController *vc = [[UploadPhotoController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.order_id = self.order_id;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (item[@"key"] && [item[@"key"] isEqualToString:@"bounds"]){
        BoundListController *vc = [[BoundListController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (item[@"url"] && ![item[@"url"] isEqualToString:@""]){
        Browser2Controller *vc = [[Browser2Controller alloc] initWithNibName:@"Browser2Controller" bundle:nil];
        vc.url = item[@"url"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (item[@"pic_url"]){

        GoodsDetailController *vc =[[GoodsDetailController alloc] initWithStyle:UITableViewStylePlain];
        vc.target_id =[item[@"id"] intValue];
        vc.title = item[@"name"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)buyButtonPressed:(BuyButtonView *)sender data:(id)data{
    NewOrderController *vc = [[NewOrderController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.order_id = self.order_id;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)load_data{
    NSString *url = [NSString stringWithFormat:@"order/order_detail?userid=%d&orderid=%@",[AppSettings sharedSettings].userid,self.order_id];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _list = [[NSMutableArray alloc] init];
            _sectionList = [[NSMutableArray alloc] init];
            _footer_index = -1;
            _order_status = json[@"result"][@"order_status"];
            _order_status_name =json[@"result"][@"order_status_name"];
            _next_form = json[@"result"][@"next_form"];
            _is_exform = [json[@"result"][@"is_exform"] intValue];
            _is_upload = [json[@"result"][@"is_upload"] intValue];
            order_url = json[@"result"][@"order_url"];
            [self setup_exform];
            int order_count=0;
            //goods information
            for (id good in json[@"result"][@"goods"]) {
                [_sectionList addObject:@""];
                [_list addObject:@[good]];
                order_count = order_count + [good[@"quantity"] intValue];
                _footer_index ++;
            }
            // order informaiton
            [_sectionList addObject:@"订单信息"];
            
            [_list addObject:@[@{@"title":@"订单号",@"detail":json[@"result"][@"order_id"],@"url":order_url},
                               @{@"title":@"消费码",@"detail":json[@"result"][@"coupon_code"],@"url":json[@"result"][@"coupon_url"]},
                               @{@"title":@"下单时间",@"detail":json[@"result"][@"order_time"]},
                               @{@"title":@"数量",@"detail":[NSString stringWithFormat:@"%d",order_count]},
                               @{@"title":@"总价",@"detail":json[@"result"][@"order_total"]},
                               @{@"title":@"当前状态",@"detail":json[@"result"][@"order_status_name"],@"url":json[@"result"][@"status_url"],@"key":@"status"}]];
            //if else depends on order_status
            if ([_order_status isEqualToString:@"notpay"]){
                //nothing
            }else{
                if (_is_upload==1){
                    [_sectionList addObject:@"上传照片"];
                    [_list addObject:@[@{@"title":@"照片",@"detail":@"上传",@"key":@"upload"}]];
                }
                if ([_next_form isEqualToString:@"address"]){
                    [_sectionList addObject:@"配送信息"];
                    [_list addObject:@[@{@"title":@"配送方式",@"detail":json[@"result"][@"shipping"]},
                                       @{@"title":@"联系人",@"detail":json[@"result"][@"name"]},
                                       @{@"title":@"电话",@"detail":json[@"result"][@"phone"]},
                                       @{@"title":@"地址",@"detail":json[@"result"][@"address"]}]];
                }else if ([_next_form isEqualToString:@"ins_contents"]){
                    [_sectionList addObject:@"家庭财产险信息"];
                    [_list addObject:@[
                                       @{@"title":@"被保险人姓名",@"detail":json[@"result"][@"name"]},
                                       @{@"title":@"电话",@"detail":json[@"result"][@"phone"]},
                                       @{@"title":@"地址",@"detail":json[@"result"][@"address"]},
                                       @{@"title":@"身份证号",@"detail":json[@"result"][@"idcard"]}]];
                }else if ([_next_form isEqualToString:@"ins_accident"]){
                    [_sectionList addObject:@"意外伤害险信息"];
                    [_list addObject:@[
                                       @{@"title":@"被保险人姓名",@"detail":json[@"result"][@"name"]},
                                       @{@"title":@"身份证号",@"detail":json[@"result"][@"idcard"]},
                                       @{@"title":@"电话",@"detail":json[@"result"][@"phone"]},
                                       @{@"title":@"职业类别",@"detail":json[@"result"][@"typename"]},
                                       ]];
                }else if ([_next_form isEqualToString:@"finished"]){
                    [_sectionList addObject:@"附加信息"];
                    [_list addObject:@[
                                       @{@"title":@"内容",@"detail":json[@"result"][@"content"],@"height":@"80",@"lines":@5},
                                      
                                       ]];
                }
            }
            
            if ([_order_status isEqualToString:@"finished"]){
                //price
                [_sectionList addObject:@"应付款"];
                [_list addObject:@[@{@"title":@"会员折扣",@"detail":json[@"result"][@"discount"]},
                                   @{@"title":@"可用积分抵扣",@"detail":json[@"result"][@"bounds"]},

                                   @{@"title":@"应付总额",@"detail":json[@"result"][@"order_pay"]}]];
                
                //pay
                [_sectionList addObject:@"付款方式"];
                NSMutableArray *paylist =[[NSMutableArray alloc] init];
                for (id pay  in json[@"result"][@"pay"]) {
                    [paylist addObject:@{@"title":pay[@"bank_name"],@"detail":pay[@"account"],@"url":pay[@"pay_url"]}];
                }
                [_list addObject:paylist];
                
                [_sectionList addObject:@"积分"];
                [_list addObject:@[@{@"title":@"订单积分",@"detail":json[@"result"][@"get_bounds"],@"key":@"bounds"}]];
            }
            
            [self.tableView reloadData];
            
        }
    }];
}
-(void)setup_exform{
    if (_is_exform==1){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(edit_exform)];
        
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}
-(void)edit_exform{
    AfterPayController *vc = [[AfterPayController alloc] init];
    [vc pushToNext:self.navigationController order_id:self.order_id];
}
@end
