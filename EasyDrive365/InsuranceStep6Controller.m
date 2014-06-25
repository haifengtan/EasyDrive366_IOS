//
//  InsuranceStep6Controller.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/27/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "InsuranceStep6Controller.h"
#import "AppSettings.h"
#import "InsuranceStep7Controller.h"
#import "WXApi.h"
#import "UPPayPlugin.h"
#import "UPPayPluginDelegate.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"

@interface InsuranceStep6Controller ()<UPPayPluginDelegate>{
    BOOL _useDiscount;
    id _pay;
    CGFloat _amount;
}

@end

@implementation InsuranceStep6Controller

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
    self.title = @"第六步";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonSystemItemAction target:self action:@selector(backTo)];
    
    _useDiscount = NO;
    [self load_data];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAfterPay:) name:ALIPAY_SUCCESS object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)load_data{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0){
        return 3;
    }else{
        return [self.order_data[@"pay"] count];
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0){
        return @"结算信息";
    }else{
        return @"付款方式";
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    if (indexPath.section==0){
        if (indexPath.row==0){
            cell.textLabel.text = @"保费总额";
            cell.detailTextLabel.text = self.order_data[@"order_total"];
        }else if (indexPath.row==1){
            cell.textLabel.text = @"积分支付";
            UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(90, 10, 120, 24)];
            label.text = self.order_data[@"bounds"];
            label.font = [UIFont fontWithName:@"Arial" size:12];
            [cell.contentView addSubview:label];
            CGRect rect;
            if ([[AppSettings sharedSettings] isIos7]){
                rect = CGRectMake(250, 10, 50, 24);
            }else{
                rect = CGRectMake(220, 10, 50, 24);
            }
            UISwitch *sw = [[UISwitch alloc] initWithFrame:rect];
            [sw setOn:_useDiscount];
            [sw addTarget:self action:@selector(switchUseDiscount:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:sw];
        }else{
            cell.textLabel.text = @"还需支付";
            cell.detailTextLabel.text = self.order_data[_useDiscount? @"order_pay":@"order_pay_2"];
        }
    }else{
        id item = [self.order_data[@"pay"] objectAtIndex:indexPath.row];
        cell.textLabel.text = item[@"bank_name"];
        cell.detailTextLabel.text = item[@"account"];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    return cell;
}
-(void)switchUseDiscount:(UISwitch *)sender{
    _useDiscount = sender.on;
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1){
        //assume pay succesuss!
        id item = [self.order_data[@"pay"] objectAtIndex:indexPath.row];
         _pay = item;
        _amount = [self.order_data[_useDiscount? @"order_pay":@"order_pay_2"] floatValue];
        if ([item[@"bank_id"] isEqualToString:@"00001"]){
           
            
            [[AppSettings sharedSettings] pay:@"在线购买保险" description:self.order_data[@"order_id"] amount:_amount order_no:self.order_data[@"order_id"]];

        }else if ([item[@"bank_id"] isEqualToString:@"62000"]){
            //up pay
            [self up_pay];
        }else if ([item[@"bank_id"] isEqualToString:@"00000"]){
            [self handleAfterPay:Nil];
        }else if ([item[@"bank_id"] isEqualToString:@"60000"]){
            [self wx_pay];
        }
    }
}
-(void)handleAfterPay:(NSNotification *)notification{
    NSLog(@"%@",notification);
    InsuranceStep7Controller *vc = [[InsuranceStep7Controller alloc] initWithStyle:UITableViewStyleGrouped];
    vc.orderid = self.order_data[@"order_id"];
    vc.bounds = _useDiscount?self.order_data[@"bounds_num"]:@"0";
    vc.bankid = _pay[@"bank_id"];
    vc.account = @"";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)up_pay{
    NSString *path= [NSString stringWithFormat:@"UnionPay/PayNewOrder/%@/%f",self.order_data[@"order_id"],_amount];
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

-(void)UPPayPluginResult:(NSString *)result{
    NSLog(@"%@",result);
    if ([result isEqualToString:@"success"]){
        [self handleAfterPay:nil];
    }
}
-(void)wx_pay{
    NSString *url = [NSString stringWithFormat:@"pay_wechat/get_prepay?userid=%d&orderid=%@&total=%f&name=%@",
                     [AppSettings sharedSettings].userid,
                     self.order_data[@"order_id"],_amount,@"在线购买保险"
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
@end
