//
//  NewOrderController.m
//  EasyDrive366
//  产品购买页面
//  Created by Steven Fu on 1/7/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "NewOrderController.h"
#import "AppSettings.h"
#import "OrderItem.h"
#import "OrderProductCell.h"
#import "OrderQuantityCell.h"
#import "UIImageView+AFNetworking.h"
#import "NewOrderHeader.h"
#import "ButtonViewController.h"
#import "OrderPayController.h"
#import "BuyButtonView.h"

@interface NewOrderController ()<OrderQuantityCellDelegate,BuyButtonViewDelegate>{
    id _list;
    NSString *_order_id;
    NSString *_order_total;
    CGFloat _price;
    BuyButtonView *_buttonView;
    NewOrderHeader *_header;
}

@end

@implementation NewOrderController

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
    self.title = @"新订单";
    [self load_data];
}

-(void)load_data{
    NSString *url;
    
    //若商品id不为空 则表示新增订单   若订单id不为空 则表示修改订单
    if (self.product_id){
        url = [NSString stringWithFormat:@"order/order_new?userid=%d&goodsid=%d",[AppSettings sharedSettings].userid,self.product_id];
    }else if (self.order_id){
        url = [NSString stringWithFormat:@"order/order_edit?userid=%d&orderid=%@",[AppSettings sharedSettings].userid,self.order_id];
    }
    
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _order_id = json[@"result"][@"order_id"];
            _order_total = json[@"result"][@"order_total"];
            _list = [[NSMutableArray alloc] init];
            for (id item in json[@"result"][@"goods"]) {
                OrderItem *orderItem = [[OrderItem alloc] initWithJson:item];
                [_list addObject:orderItem];
            }

            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [_list count]*2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!section % 2){
        return 1;
    }else{
        return 3;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    int index = indexPath.section / 2;
    OrderItem *item = [_list objectAtIndex:index];
    if (!indexPath.section %2){
        if (cell==Nil){
            cell =[[[NSBundle mainBundle] loadNibNamed:@"OrderProductCell" owner:nil options:nil] objectAtIndex:0];
            
            
        }
        OrderProductCell *productCell = (OrderProductCell *)cell;
        [productCell.imageProduct setImageWithURL:[NSURL URLWithString:item.pic_url]];
        productCell.lblName.text= item.name;
        productCell.lblDescription.text = item.description;
        productCell.lblPrice.text = item.price;
        productCell.lblStand_price.text = item.stand_price;
        productCell.lblStand_price.strikeThroughEnabled = YES;
        productCell.lblDiscount.text = item.discount;
        productCell.lblBuyer.text = item.buyer;
        
    
    }else{
        if (indexPath.row==0){
            if (cell==nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            cell.textLabel.text=@"单价";
            cell.detailTextLabel.text= item.price;
        }else if (indexPath.row==1){
            if (cell==nil){
                cell= [[[NSBundle mainBundle] loadNibNamed:@"OrderQuantityCell" owner:nil options:nil] objectAtIndex:0];
            }
            OrderQuantityCell *quantityCell = (OrderQuantityCell *)cell;
            quantityCell.lblQuantity.text = [NSString stringWithFormat:@"%d",item.quantity];
            quantityCell.delegate = self;
            if (item.max_quantity && item.min_quantity){
                quantityCell.stepper.minimumValue = item.min_quantity;
                quantityCell.stepper.maximumValue = item.max_quantity;
            }
            
        }else if (indexPath.row==2){
            if (cell==nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            cell.textLabel.text=@"合计";
            cell.detailTextLabel.text=_order_total;
        }
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!indexPath.section % 2){
        return 120.0f;
    }else{
        return 44.0f;
    }
}
-(void)quantityChanged:(UITableViewCell *)cell value:(int)value{
    NSIndexPath *indexPath =[self.tableView indexPathForCell:cell];
    NSIndexPath *nextCell = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
    int index = indexPath.section / 2;
    OrderItem *orderItem = [_list objectAtIndex:index];
    orderItem.quantity = value;
    _order_total = [NSString stringWithFormat:@"¥%0.2f元",value*orderItem.price_num];
    [self.tableView reloadRowsAtIndexPaths:@[nextCell] withRowAnimation:UITableViewRowAnimationTop];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==[_list count]*2-1){
        return 60.0f;
    }
    return 11.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 22.0f;
        //return 44.0f;
    }
    return 11.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0){
        /*
        if (!_header){
            _header =[[[NSBundle mainBundle] loadNibNamed:@"NewOrderHeader" owner:nil options:nil] objectAtIndex:0];
        }
        return _header;
         */
        return nil;
    }
    return  nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==[_list count]*2-1){
        if (!_buttonView){
            _buttonView =[[[NSBundle mainBundle] loadNibNamed:@"BuyButtonView" owner:nil options:nil] objectAtIndex:0];
            [_buttonView.btnBuy setBackgroundImage:[UIImage imageNamed:@"btnpay_big"] forState:UIControlStateNormal];
            _buttonView.delegate = self;

        }
        return _buttonView;
    }
    return nil;
}

/**
 *  点击购买按钮   保持订单信息   跳转到支付页面
 *
 *  @param sender <#sender description#>
 *  @param data   <#data description#>
 */
-(void)buyButtonPressed:(BuyButtonView *)sender data:(id)data{

    if ([_list count]==0)
        return;
    OrderItem *item = [_list objectAtIndex:0];
    NSString *url = [NSString stringWithFormat:@"order/order_save?userid=%d&goodsid=%d&quantity=%d&orderid=%@",
                     [AppSettings sharedSettings].userid,item.orderitem_id,item.quantity,_order_id];
    
    //保存订单成功后 跳转到支付页面
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            OrderPayController *vc =[[OrderPayController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.data = json[@"result"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}
@end
