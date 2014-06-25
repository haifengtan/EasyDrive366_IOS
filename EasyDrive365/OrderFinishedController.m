//
//  OrderFinishedController.m
//  EasyDrive366
//  订单完成页面
//  Created by Steven Fu on 1/28/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "OrderFinishedController.h"
#import "OrderDetailController.h"

@interface OrderFinishedController ()

@end

@implementation OrderFinishedController

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
    self.title = @"订单完成";
    self.txtContent.text = self.content_data[@"content"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  返回商品列表页面
 *
 *  @param sender <#sender description#>
 */
- (IBAction)gobackGoodsPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:OPEN_GOODS object:Nil];
}

/**
 *  查看商品详细页面
 *
 *  @param sender <#sender description#>
 */
- (IBAction)goOrderDetailPressed:(id)sender {
    OrderDetailController *vc = [[OrderDetailController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.order_id = self.content_data[@"order_id"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
