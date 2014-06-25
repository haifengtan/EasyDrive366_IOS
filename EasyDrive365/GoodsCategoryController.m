//
//  GoodsCategoryController.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/11/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "GoodsCategoryController.h"
#import "AppSettings.h"
#import "ServiceType.h"
#import "SearchResultController.h"
#import "GoodsListController.h"
#import "ProviderListController.h"
#import "ArticleListController.h"

@interface GoodsCategoryController ()<UISearchBarDelegate>{
    id _list;
    UISearchBar *_searchBar;
}

@end

@implementation GoodsCategoryController

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查询" style:UIBarButtonSystemItemAction target:self action:@selector(searchCategory)];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 170, 320, 44)];
    _searchBar.placeholder = @"请输入查询条件";
    _searchBar.delegate = self;
    [[self tableView] setTableHeaderView:_searchBar];
    if ([self.type isEqualToString:@"goods"]){
        self.title = @"搜索";
    }else if ([self.type isEqualToString:@"provider"]){
        self.title = @"商户分类";
    }else{
        self.title = @"百科分类";
    }

}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self doSearch:searchBar.text];
}
-(void)searchCategory{
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
    [_refreshHelper endRefresh:self.tableView];
    /*
    SearchResultController *vc =[[SearchResultController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.key = key;
    vc.types = types;
     */
    
    
    if ([self.type isEqualToString:@"goods"]){

        GoodsListController *vc = [[GoodsListController alloc] initWithStyle:UITableViewStylePlain];
        vc.isSearch = YES;
        vc.searchKey = key;
        vc.searchTypes = types;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.type isEqualToString:@"provider"]){
        ProviderListController *vc = [[ProviderListController alloc] initWithStyle:UITableViewStylePlain];
        vc.isSearch = YES;
        vc.searchKey = key;
        vc.searchTypes = types;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ArticleListController *vc = [[ArticleListController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.isSearch = YES;
        vc.searchKey = key;
        vc.searchTypes = types;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setup{
    _helper.url=[NSString stringWithFormat:@"api/get_service_type?userid=%d&type=%@",[AppSettings sharedSettings].userid,self.type];
    
}
-(void)processData:(id)json{
    if ([[AppSettings sharedSettings] isSuccess:json]){
        if (_list){
            [_list removeAllObjects];
        }else{
            _list = [[NSMutableArray alloc] init];
        }
        for (id item  in json[@"result"]) {
            ServiceType *st = [[ServiceType alloc] initWithJson:item];
            if ([st.code isEqualToString:@"00"]){
                st.checked = YES;
            }
            [_list addObject:st];
        }
        
        
        [self.tableView reloadData];
    }
    [_refreshHelper endRefresh:self.tableView];
}

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
