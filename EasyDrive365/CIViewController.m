//
//  CIViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 3/20/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "CIViewController.h"
#import "InfoAndPriceCell.h"
#import "PhoneView.h"

@interface CIViewController (){
    int _currentType;
    NSDictionary *_dict;
    NSMutableArray *_list;
    id _json;
}

@end

@implementation CIViewController

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
    self.tableView.delegate=self;
    self.tableView.dataSource = self;
    self.tabbar.delegate = self;
    
    UITabBarItem *item1=[[UITabBarItem alloc] initWithTitle:@"基础费率" image:[UIImage imageNamed:@"0083.png"] tag:0];
    [self.tabbar setItems:@[item1,
     [[UITabBarItem alloc] initWithTitle:@"保险责任" image:[UIImage imageNamed:@"0051.png"] tag:1],
     [[UITabBarItem alloc] initWithTitle:@"浮动因素" image:[UIImage imageNamed:@"0228.png"] tag:2]]];
    [self.tabbar setSelectedItem:item1];
    [self setupTableView:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTabbar:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    _currentType = item.tag;
    [self update_display];
}

-(void)setup{
    _helper.url =[NSString stringWithFormat:@"api/get_compulsory_details?userid=%d",[_helper appSetttings].userid];
}
-(void)processData:(id)json{
    _company = json[@"result"][@"company"];
    _phone = json[@"result"][@"phone"];
    _json = json;
    
    
    
    [self update_display];
    [self endRefresh:self.tableView];
}
-(void)update_display{
    NSString *type_name=[NSString stringWithFormat:@"type_%d",_currentType];
    _dict =_json[@"result"][@"data"][type_name];
    if (!_list){
        _list =[[NSMutableArray alloc] init];
    }else{
        [_list removeAllObjects];
    }
    NSArray *newList = [[_dict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *s1 = obj1;
        NSString *s2 = obj2;
        return [s1 compare:s2];
    }];
    [_list addObjectsFromArray:newList];
    [self.tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_list count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id key=[_list objectAtIndex:section];
    return [[_dict objectForKey:key] count];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    InfoAndPriceCell *cell=nil;
    cell =[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil){
        //cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell =[[[NSBundle mainBundle] loadNibNamed:@"InfoAndPriceCell" owner:nil options:nil] objectAtIndex: 0];
    }
    //id key=[[_dict allKeys] objectAtIndex:indexPath.section];
    id key =[_list objectAtIndex:indexPath.section];
    id item =[[_dict objectForKey:key] objectAtIndex:indexPath.row];
    cell.titleLabel.text=item[@"name"];
    cell.detailLabel.text=item[@"price"];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_list objectAtIndex:section];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0 && _currentType==0){
        PhoneView *phoneView = [[[NSBundle mainBundle] loadNibNamed:@"PhoneView" owner:nil options:nil] objectAtIndex:0];
        [phoneView initWithPhone:_company phone:_phone];
        phoneView.backgroundColor = tableView.backgroundColor;
        return phoneView;
        
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0){
        return 80;
    }else{
        return 22;
    }
}
@end
