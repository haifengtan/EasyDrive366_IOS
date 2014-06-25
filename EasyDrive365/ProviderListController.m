//
//  ProviderListController.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/11/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ProviderListController.h"
#import "ProviderListItemCell.h"
#import "UIImageView+AFNetworking.h"
#import "GoodsCategoryController.h"
#import "ProviderDetailController.h"

@interface ProviderListController (){
    id _list;
}

@end

@implementation ProviderListController

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
    self.title = @"服务商";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setup{
    if (self.isSearch){
        _helper.url = [NSString stringWithFormat:@"api/get_service_list?userid=%d&type=%@&keyword=%@",[AppSettings sharedSettings].userid,self.searchTypes,self.searchKey];
        //self.title = @"商户查询";
    }else{
        _helper.url = [NSString stringWithFormat:@"api/get_service_list?userid=%d",[AppSettings sharedSettings].userid];
        //self.title = @"推荐商户";
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

-(void)openCategory{
    GoodsCategoryController *vc = [[GoodsCategoryController alloc] initWithStyle:UITableViewStylePlain];
    vc.type=@"provider";
    [self.navigationController pushViewController:vc animated:YES];
}


@end
