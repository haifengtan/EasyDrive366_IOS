//
//  MaintainListViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/14/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "MaintainListViewController.h"
#import "AppSettings.h"
#import "HttpClient.h"
#import "MaintainRecordDetailViewController.h"
#import "ItemDetailCell.h"

@interface MaintainListViewController (){
    NSMutableArray *_list;
}

@end

@implementation MaintainListViewController

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
    
    [self loadData];
}
-(void)loadData{
    [[HttpClient sharedHttp] get:[AppSettings sharedSettings].url_for_maintain_list block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            if (_list){
                [_list removeAllObjects];
            }else{
                _list =[[NSMutableArray alloc] init];
            }
            [_list addObjectsFromArray:[json objectForKey:@"result"][@"data"]];
            [self updateData];
            
        }else{
            //get nothing from server;
        }
    }];

}
-(void)updateData{
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
    return _list?[_list count]:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ItemDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"ItemDetailCell" owner:self.tableView options:nil];
        cell =cells[0];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    id item =[_list objectAtIndex:indexPath.row];
    cell.titleLabel.text = item[@"company"];
    cell.detailLabel.text = item[@"issue"];
    cell.dateLabel.text = item[@"date"];
    cell.priceLabel.text= item[@"money"];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item =[_list objectAtIndex:indexPath.row];
    MaintainRecordDetailViewController *vc =[[MaintainRecordDetailViewController alloc] initWithNibName:@"MaintainRecordDetailViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc setData:item];
}

@end
