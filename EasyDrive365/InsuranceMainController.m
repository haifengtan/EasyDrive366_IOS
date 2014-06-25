//
//  InsuranceMainController.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/26/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "InsuranceMainController.h"
#import "MenuItem.h"
#import "Menu.h"
#import "NavigationCell.h"
#import "AppSettings.h"
@interface InsuranceMainController (){
    id _list;
}

@end

@implementation InsuranceMainController

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
    _list = [Menu sharedMenu].insurance_list;
    [[AppSettings sharedSettings] get_insurance_latest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_list count] ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NavigationCell"  owner:self options:nil];
    NavigationCell *cell =[nib objectAtIndex:0];
    MenuItem *item = [_list objectAtIndex:indexPath.row];
    ((NavigationCell *)cell).titleLabel.text = item.title;
    ((NavigationCell *)cell).keyname = item.name;
    if (item.imagePath && ![item.imagePath isEqualToString:@""]){
        ((NavigationCell *)cell).imgeIcon.image = [UIImage imageNamed:item.imagePath];
    }
    cell.rootController = self.navigationController;
    return cell;
    
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MenuItem *item = [_list objectAtIndex:indexPath.row];
    NSLog(@"Select %@",item.title);
    [[Menu sharedMenu] pushToController:self.navigationController key:item.name title:item.title url:nil];
    
    
}
@end
