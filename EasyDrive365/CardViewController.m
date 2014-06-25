//
//  CardViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 10/21/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "CardViewController.h"
#import "SingleCardViewController.h"

@interface CardViewController (){
    id _list;
}

@end

@implementation CardViewController

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
    self.title = @"保险卡单查看";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonSystemItemAction target:self action:@selector(backToSettings)];
}
-(void)backToSettings{
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1]  animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setup{
    _helper.url =[NSString stringWithFormat:@"api/get_inscard_list?userid=%d",[AppSettings sharedSettings].userid];
    
}
-(void)processData:(id)json{
    _list = json[@"result"][@"data"];

    [self update_data];
}
-(void)update_data{
    [self.tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_list count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"InsCardTableCellView";
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    id item =[_list objectAtIndex:indexPath.row];

    cell.textLabel.text = item[@"title"];
    cell.detailTextLabel.text = item[@"valid"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item =[_list objectAtIndex:indexPath.row];
    SingleCardViewController *vc =[[SingleCardViewController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.data = item;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
