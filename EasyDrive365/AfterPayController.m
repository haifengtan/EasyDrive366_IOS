//
//  AfterPayController.m
//  EasyDrive366
//  支付成功后的处理
//  Created by Steven Fu on 2/22/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "AfterPayController.h"
#import "OrderFinishedController.h"
#import "OrderAddressController.h"
#import "OrderContentController.h"
#import "OrderAccidentController.h"
#import "AppSettings.h"

@implementation AfterPayController

/**
 *  支付成功后的处理
 *
 *  @param controller <#controller description#>
 *  @param json       <#json description#>
 *  @param hasBack    是否隐藏返回按钮
 */
-(void)pushToNext:(UINavigationController *)controller json:(id)json hasBack:(BOOL)hasBack{
    NSString *next_form =json[@"result"][@"next_form"];
    NSLog(@"%@",json[@"result"]);
    if ([next_form isEqualToString:@"finished"]){
        //订单完成
        OrderFinishedController *vc = [[OrderFinishedController alloc] initWithNibName:@"OrderFinishedController" bundle:Nil];
        vc.content_data= json[@"result"];
        [controller pushViewController:vc animated:YES];
    }else if ([next_form isEqualToString:@"address"]){
        //跳转到填写配送信息页面
        OrderAddressController *vc =[[OrderAddressController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.address_data = json[@"result"];
        vc.hasBack = hasBack;
        [controller pushViewController:vc animated:YES];
    }else if ([next_form isEqualToString:@"ins_contents"]){
        //跳转到填写其他信息页面
        OrderContentController *vc =[[OrderContentController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.ins_data = json[@"result"];
        vc.hasBack = hasBack;
        [controller pushViewController:vc animated:YES];
    }else if ([next_form isEqualToString:@"ins_accident"]){
        
        OrderAccidentController *vc =[[OrderAccidentController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.ins_data = json[@"result"];
        vc.hasBack = hasBack;
        [controller pushViewController:vc animated:YES];
    }
}
-(void)pushToNext:(UINavigationController *)controller order_id:(NSString *)order_id{
    NSString *url =[NSString stringWithFormat:@"order/order_exform?userid=%d&orderid=%@",[AppSettings sharedSettings].userid,order_id];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            [self pushToNext:controller json:json hasBack:YES];
        }
    }];
}
@end
