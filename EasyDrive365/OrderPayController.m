//
//  OrderPayController.m
//  EasyDrive366
//  订单支付页面
//  Created by Steven Fu on 1/7/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "OrderPayController.h"
#import "PayUseDiscountCell.h"
#import "AppSettings.h"
#import "OrderAddressController.h"
#import "OrderFinishedController.h"
#import "OrderAccidentController.h"
#import "OrderContentController.h"
#import "AfterPayController.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "UPPayPlugin.h"
#import "UPPayPluginDelegate.h"
#import "WXApi.h"
#import <CommonCrypto/CommonDigest.h>

@interface OrderPayItem:NSObject
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *detail;
@property (nonatomic) BOOL useDiscount;
@property (nonatomic,weak) UITableViewCell *cell;
@end


@implementation OrderPayItem



@end

@interface OrderPayController ()<PayUseDiscountCellDelegate,UPPayPluginDelegate,WXApiDelegate>{
    id _list;
    id _sectionlist;
    OrderPayItem *_payItem;
    id _pay;
    NSString *_name;
    NSString *_description;
    NSString *_price;
    CGFloat _amount;
}

@end

@implementation OrderPayController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAfterPay:) name:ALIPAY_SUCCESS object:nil];
    [self load_data];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



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
    if ([item[@"cell"] isEqualToString:@"switch"]){
        cell =[[[NSBundle mainBundle] loadNibNamed:@"PayUseDiscountCell" owner:Nil options:nil] objectAtIndex:0];
    }else{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    if ([item[@"cell"] isEqualToString:@"switch"]){
        PayUseDiscountCell *payCell = (PayUseDiscountCell *)cell;
        payCell.lblTitle.text =item[@"title"];
        payCell.lblDetail.text =item[@"detail"];
        payCell.delegate = self;
        payCell.switchUse.on = _payItem.useDiscount;
        _payItem.cell = payCell;
    }else if (item[@"object"]){
        cell.textLabel.text = item[@"title"];
        cell.detailTextLabel.text = _payItem.detail;
    }else{
        cell.textLabel.text = item[@"title"];
        cell.detailTextLabel.text = item[@"detail"];
    }
    
    if (item[@"item"]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_sectionlist objectAtIndex:section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(void)settingsChanged:(UITableViewCell *)cell value:(BOOL)value{
    _payItem.useDiscount = value;
    _payItem.detail = value?self.data[@"order_pay"]:self.data[@"order_pay_2"];
    //[self.tableView reloadRowsAtIndexPaths:@[_payItem.cell] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = [[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (item[@"item"] && item[@"pay"]){
        //doing pay
        
        _pay = item[@"item"];
        NSLog(@"%@",_pay);
        _amount = [_payItem.detail floatValue];
        if ([item[@"item"][@"bank_id"] isEqualToString:@"00001"]){
            _amount = [_payItem.detail floatValue];
            if (_amount < 0.009){
                [[[UIAlertView alloc] initWithTitle:AppTitle message:@"应付金额为0不能使用支付宝支付" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
                return;
            }
            [[AppSettings sharedSettings] pay:_name description:_description amount:_amount order_no:self.data[@"order_id"]];
            
        }else if ([item[@"item"][@"bank_id"] isEqualToString:@"62000"]){
            //up pay
            [self up_pay];
        }else if ([item[@"item"][@"bank_id"] isEqualToString:@"00000"]){
            [self handleAfterPay:Nil];
        }else if ([item[@"item"][@"bank_id"] isEqualToString:@"60000"]){
            [self wx_pay];
        }
    }
}

/**
 *  加载支付信息
 */
-(void)load_data{
    if (self.data){
        NSLog(@"%@",self.data);
        _list = [[NSMutableArray alloc] init];
        _sectionlist = [[NSMutableArray alloc] init];
        //productions
        for (id good in self.data[@"goods"]) {
            /*
             [_list addObject:@[@{@"title":@"单价",@"detail":good[@"price"]},@{@"title":@"数量",@"detail":[NSString stringWithFormat:@"%@",good[@"quantity"]]}]];
             [_sectionlist addObject:good[@"name"]];
             */
            _name = good[@"name"];
            _description = good[@"name"];//missing description for good's description
            _price = good[@"price"];
            _amount = [good[@"quantity"] floatValue];
        }
        //money information
        [_sectionlist addObject:@"应付款"];
        _payItem = [[OrderPayItem alloc] init];
        _payItem.useDiscount = NO;
        _payItem.detail = self.data[@"order_pay_2"];
        
        [_list addObject:@[@{@"title":@"总价",@"detail":self.data[@"order_total"]},
                           @{@"title":@"会员折扣",@"detail":self.data[@"discount"]},
                           @{@"title":@"积分支付",@"detail":self.data[@"bounds"],@"cell":@"switch"},
                           @{@"title":@"应付总额",@"detail":self.data[@"order_pay"],@"object":@"1"}]];
        
        //pay method
        [_sectionlist addObject:@"付款方式"];
        id paylist = [[NSMutableArray alloc] init];
        for (id pay in self.data[@"pay"]) {
            [paylist addObject:@{@"title": pay[@"bank_name"],@"detail":pay[@"account"],@"item":pay,@"pay":@"yes"}];
        }
        [_list addObject:paylist];
        [self.tableView reloadData];
        
        self.title = [NSString stringWithFormat:@"Order[%@]",self.data[@"order_id"]];
    }
}

/**
 *  支付成功后的处理
 *
 *  @param notification <#notification description#>
 */
-(void)handleAfterPay:(NSNotification *)notification{
    NSLog(@"%@",notification);
    NSString *bounds = _payItem.useDiscount?self.data[@"bounds_num"]:@"0";
    NSString *url = [NSString stringWithFormat:@"order/order_payed?userid=%d&orderid=%@&orderpay=%f&bounds=%@&bankid=%@&account=%@",[AppSettings sharedSettings].userid,self.data[@"order_id"],_amount,bounds,_pay[@"bank_id"],_pay[@"bank_name"]];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            AfterPayController *vc = [[AfterPayController alloc] init];
            [vc pushToNext:self.navigationController json:json hasBack:NO];
            
        }
    }];
    
}

/**
 *  银联支付
 */
-(void)up_pay{
    NSString *path= [NSString stringWithFormat:@"UnionPay/PayNewOrder/%@/%f",self.data[@"order_id"],_amount];
    NSURL *url = [NSURL URLWithString:@"http://payment.yijia366.cn/"];
    AFHTTPClient *httpClient =[[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSMutableURLRequest *request=[httpClient requestWithMethod:@"GET"  path:path parameters:nil];
    NSLog(@"Request=%@",request.URL);
    AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        id jsonResult =[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"get Result=%@",jsonResult);
        [UPPayPlugin startPay:jsonResult[@"tn"] mode:@"00" viewController:self delegate:self];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Access server error:%@,because %@",error,operation.request);
        
        
    }];
    NSOperationQueue *queue=[[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

/**
 *  支付结果处理
 *
 *  @param result <#result description#>
 */
-(void)UPPayPluginResult:(NSString *)result{
    NSLog(@"%@",result);
    if ([result isEqualToString:@"success"]){
        //支付成功
        [self handleAfterPay:nil];
    }else{
        //支付失败
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"支付失败！" delegate:Nil cancelButtonTitle:@"关闭" otherButtonTitles: nil] show];
    }
}

/**
 *  微信支付
 */
-(void)wx_pay{
    NSString *url = [NSString stringWithFormat:@"pay_wechat/get_prepay?userid=%d&orderid=%@&total=%f&name=%@",
                     [AppSettings sharedSettings].userid,
                     self.data[@"order_id"],
                     _amount,
                     _name
                     
                     ];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            PayReq *request =[[PayReq alloc] init];
            request.partnerId = WEIXIN_PARTENERID;
            request.prepayId = json[@"result"][@"prepayid"];
            request.package = @"Sign=WXPay";
            request.nonceStr = json[@"result"][@"noncestr"];
            
            
            request.timeStamp = [json[@"result"][@"timestamp"] intValue];
            request.sign = json[@"result"][@"sign"];
            [WXApi safeSendReq:request];
            
        }
    }];
}
-(void)onResp:(BaseResp *)resp{
    NSLog(@"%@",resp);
}

@end
