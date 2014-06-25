//
//  GoodsShopListController.m
//  EasyDrive366
//
//  Created by Steven Fu on 4/3/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "GoodsShopListController.h"
#import "ProviderListItemCell.h"
#import "UIImageView+AFNetworking.h"

#import "ProviderDetailController.h"
#import "ShowLocationViewController.h"

@interface GoodsShopListController (){
    id _list;
}

@end

@implementation GoodsShopListController

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
    self.title = @"服务网点";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"地图" style:UIBarButtonItemStyleBordered target:self action:@selector(openMap)];
    NSString *url = [NSString stringWithFormat:@"goods/list_goods_service?userid=%d&id=%d",[AppSettings sharedSettings].userid,self.goods_id];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _list =json[@"result"];
            [self.tableView reloadData];
        }
    }];
}
-(void)openMap{
    ShowLocationViewController *vc =[[ShowLocationViewController alloc] initWithNibName:@"ShowLocationViewController" bundle:nil];
    vc.target_list = _list;
    [self.navigationController pushViewController:vc animated:YES];
//    [vc showShop:_list];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_list count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil){
        cell= [[[NSBundle mainBundle] loadNibNamed:@"ProviderListItemCell" owner:nil options:nil] objectAtIndex:0];
    }
    id item = [_list objectAtIndex:indexPath.row];
    ProviderListItemCell *itemCell=(ProviderListItemCell *)cell;
    itemCell.lblName.text =item[@"name"];
    itemCell.lblAddress.text = item[@"address"];
    itemCell.lblPhone.text = item[@"phone"];
    itemCell.lblVoternum.text =[NSString stringWithFormat:@"%@", item[@"star_voternum"]];
    itemCell.rating = [item[@"star_num"] intValue];
    
    [itemCell.image setImageWithURL:[NSURL URLWithString:item[@"pic_url"]]];
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = [_list objectAtIndex:indexPath.row];
    ProviderDetailController *vc = [[ProviderDetailController alloc] initWithStyle:UITableViewStylePlain];
    vc.code= item[@"code"];
    
    vc.name = item[@"name"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
