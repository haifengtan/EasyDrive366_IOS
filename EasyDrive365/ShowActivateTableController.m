//
//  ShowActivateTableController.m
//  EasyDrive366
//
//  Created by Fu Steven on 8/14/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ShowActivateTableController.h"

@interface ShowActivateTableController ()

@end

@implementation ShowActivateTableController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"激活信息";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [_list count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [[_list objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    
    id item = [[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = item[@"title"];
    cell.detailTextLabel.text = item[@"detail"];
    
    return cell;
}
-(void)setData:(NSString *)name code:(NSString *)code activate_date:(NSString *)activate_date valid_date:(NSString *)valid_date contents:(NSArray *)contents{
    id list1=@[@{@"title":@"卡号",@"detail":name},
               @{@"title":@"激活码",@"detail":code},
               @{@"title":@"激活日期",@"detail":activate_date},
               @{@"title":@"有效期至",@"detail":valid_date}];
    NSMutableArray *list2 =[[NSMutableArray alloc] initWithCapacity:[contents count]];
    for (id item  in contents) {
        [list2 addObject:@{@"title":item[@"name"],@"detail":[NSString stringWithFormat:@"%@次",item[@"count"]]}];
    }
    _list = @[list1,list2];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==1){
        return @"服务项目";
    }else{
        return  nil;
    }
}
@end
