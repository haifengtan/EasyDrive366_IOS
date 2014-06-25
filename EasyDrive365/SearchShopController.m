//
//  SearchShopController.m
//  EasyDrive366
//
//  Created by Fu Steven on 9/18/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "SearchShopController.h"
#import "AppSettings.h"
#import "SearchResultController.h"
#import "ServiceType.h"

@interface SearchShopController ()<UISearchBarDelegate>{
    id _list;
    UISearchBar *_searchBar;
}

@end

@implementation SearchShopController

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

    self.title = @"搜索服务商";
 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查询" style:UIBarButtonSystemItemAction target:self action:@selector(searchShop)];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,170,320,44)];
    _searchBar.delegate = self;
    [[self tableView] setTableHeaderView:_searchBar];
    [self initData];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self doSearch:searchBar.text];
}
-(void)searchShop{
    [self doSearch:_searchBar.text];
}
-(void)doSearch:(NSString *)key{
    [_searchBar resignFirstResponder];
    NSMutableString *types=[[NSMutableString alloc] init];
    for (ServiceType *st in _list) {
        if (st.checked){
            [types appendString:st.code];
            [types appendString:@","];
        }
    }
    NSLog(@"%@",types);
    
    SearchResultController *vc =[[SearchResultController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.key = key;
    vc.types = types;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initData{
    NSString *url =[NSString stringWithFormat:@"api/get_service_type?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            if (_list){
                [_list removeAllObjects];
            }else{
                _list = [[NSMutableArray alloc] init];
            }
            for (id item  in json[@"result"]) {
                ServiceType *st = [[ServiceType alloc] initWithJson:item];
                [_list addObject:st];
            }
            
            
            [self.tableView reloadData];
        }
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    ServiceType *st = [_list objectAtIndex:indexPath.row];
    cell.textLabel.text= st.name;
    if (st.checked)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceType *st = [_list objectAtIndex:indexPath.row];
    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    st.checked =!st.checked;
    if (st.checked)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
}

@end
