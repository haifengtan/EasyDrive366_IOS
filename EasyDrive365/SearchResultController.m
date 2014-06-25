//
//  SearchResultController.m
//  EasyDrive366
//
//  Created by Fu Steven on 9/18/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "SearchResultController.h"
#import "AppSettings.h"
#import "ShowLocationViewController.h"
@interface SearchResultController (){
    id _list;
}

@end

@implementation SearchResultController

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

    self.title = @"服务商列表";
 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"地图" style:UIBarButtonSystemItemAction target:self action:@selector(map)];
    NSString *url = [NSString stringWithFormat:@"api/get_service_list?userid=%d&type=%@&keyword=%@",[AppSettings sharedSettings].userid,self.types,self.key];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _list = json[@"result"];
            [self.tableView reloadData];
        }
    }];
}
-(void)map{
    ShowLocationViewController *vc = [[ShowLocationViewController alloc] initWithNibName:@"ShowLocationViewController" bundle:nil];
    vc.isFull = NO;
    [self.navigationController pushViewController:vc animated:YES];
    [vc showShop:_list];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    id item = [_list objectAtIndex:indexPath.row];
    cell.textLabel.text=item[@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@(%@)",item[@"address"],item[@"phone"]];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [_list objectAtIndex:indexPath.row];
    ShowLocationViewController *vc = [[ShowLocationViewController alloc] initWithNibName:@"ShowLocationViewController" bundle:nil];
    vc.isFull = NO;
    [self.navigationController pushViewController:vc animated:YES];
    [vc showSingleShop:item];
    
}

@end
