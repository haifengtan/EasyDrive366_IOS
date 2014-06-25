//
//  ChooseUserController.m
//  EasyDrive366
//
//  Created by Fu Steven on 4/19/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ChooseUserController.h"
#import "AppSettings.h"

@interface ChooseUserController (){
    NSMutableArray *_list;
    id _selected_user;
}

@end

@implementation ChooseUserController

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStyleDone target:self action:@selector(choose)];
    [self init_data];
}
-(void)init_data{
    NSMutableArray *temp =[[AppSettings sharedSettings] get_logins];
    _list =[[NSMutableArray alloc] initWithCapacity:[temp count]];
    for(int i=[temp count]-1;i>-1;i--){
        id item = [temp objectAtIndex:i];
        NSMutableDictionary *user =[[NSMutableDictionary alloc] initWithDictionary:item];
        [user setObject:@"0" forKey:@"selected"];
        [_list addObject:user];
    }
    [self.tableView reloadData];
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
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    id user = [_list objectAtIndex:indexPath.row];
    cell.textLabel.text = user[@"username"];
    
    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    id user = [_list objectAtIndex:indexPath.row];
    user[@"selected"] =@"0";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id user = [_list objectAtIndex:indexPath.row];
    user[@"selected"] =@"1";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    _selected_user = user;
    NSLog(@"%@",user);
    [self choose];
}
-(void)choose{
    if (_selected_user){
        if ([_selected_user[@"remember"] intValue]==1){
            [[AppSettings sharedSettings] login:_selected_user[@"username"] password:_selected_user[@"password"] remember:_selected_user[@"remember"] callback:^(BOOL loginSuccess) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Choose_user" object:_selected_user];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
