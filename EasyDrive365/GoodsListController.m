//
//  GoodsListController.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "GoodsListController.h"
#import "GoodsListItemCell.h"
#import "UIImageView+AFNetworking.h"
#import "GoodsCategoryController.h"
#import "GoodsDetailController.h"
#import "BuyButtonDelegate.h"
#import "NewOrderController.h"
#import "InsuranceStep1Controller.h"

@interface GoodsListController ()<BuyButtonDelegate>{
    id _list;
}

@end

@implementation GoodsListController

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
    self.title = @"商品";
    
    
}

-(void)openCategory{
    GoodsCategoryController *vc = [[GoodsCategoryController alloc] initWithStyle:UITableViewStylePlain];
    vc.type=@"goods";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setup{
    if (self.isSearch){
        _helper.url = [NSString stringWithFormat:@"goods/get_goods_list?userid=%d&type=%@&keyword=%@",[AppSettings sharedSettings].userid,self.searchTypes,self.searchKey];
        //self.title = @"商品查询";
    }else{
        _helper.url = [NSString stringWithFormat:@"goods/get_goods_list?userid=%d",[AppSettings sharedSettings].userid];
        //self.title = @"推荐商品";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分类" style:UIBarButtonSystemItemAction target:self action:@selector(openCategory)];
    }
    
    
}
-(void)processData:(id)json{
    _list = json[@"result"];
    [self.tableView reloadData];
    [_refreshHelper endRefresh:self.tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_list count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil){
        cell= [[[NSBundle mainBundle] loadNibNamed:@"GoodsListItemCell" owner:nil options:nil] objectAtIndex:0];
    }
    id item = [_list objectAtIndex:indexPath.row];
    GoodsListItemCell *itemCell=(GoodsListItemCell *)cell;
    itemCell.lblTitle.text =item[@"name"];
    itemCell.lblPrice.text = item[@"price"];
    itemCell.lblStand_price.text = item[@"stand_price"];
    itemCell.lblStand_price.strikeThroughEnabled = YES;
    itemCell.lblDiscount.text = item[@"discount"];
    itemCell.lblDescription.text = item[@"description"];
    itemCell.lblBuyer.text=item[@"buyer"];
    itemCell.item = item;
    itemCell.delegate = self;
    [itemCell.image setImageWithURL:[NSURL URLWithString:item[@"pic_url"]]];
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = [_list objectAtIndex:indexPath.row];
    GoodsDetailController *vc =[[GoodsDetailController alloc] initWithStyle:UITableViewStylePlain];
    vc.target_id =[item[@"id"] intValue];
    vc.title = item[@"name"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)BuyButtonDelegate:(id)item{
    NSLog(@"%@",item);
    if ([item[@"is_carins"] intValue]==0){
        NewOrderController *vc = [[NewOrderController alloc] initWithStyle:UITableViewStylePlain];
        vc.product_id = [item[@"id"] intValue];
        vc.min =[item[@"min_quantity"] intValue];
        vc.max =[item[@"max_quantity"] intValue];
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        InsuranceStep1Controller *vc =[[InsuranceStep1Controller alloc] initWithNibName:@"InsuranceStep1Controller" bundle:nil];
        vc.title = item[@"name"];
        vc.web_url = item[@"web_url"];
        vc.goods_id = [item[@"id"] intValue];
        [self.navigationController pushViewController:vc animated:YES];

    }
    
}
@end
