//
//  LicenseTypeViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/17/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "LicenseTypeViewController.h"

@interface LicenseTypeViewController (){
    id _list;
    NSString *_filter;
}

@end

@implementation LicenseTypeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
-(void)setValue:(NSString *)value{
    _filter = value;
    if (_list){
        [self setupFilter];
    }
    

}
-(void)setupCellAccessory:(UITableViewCell *)cell{
    if (_filter){
        NSRange range =[_filter rangeOfString:cell.textLabel.text];
        if (range.length>0){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType =UITableViewCellAccessoryNone;
        }
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
}
-(void)setupFilter{
    
    for(id item in _list){
        if (_filter){
            NSRange range = [_filter rangeOfString:item[@"code"]];
            if (range.length>0){
                [item setObject:@"yes" forKey:@"checked"];
            }else{
                [item setObject:@"no" forKey:@"checked"];
            }
        }else{
            [item setObject:@"no" forKey:@"checked"];
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =@"驾照类型";
    
     self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(select:)];
}
-(void)select:(id)sender{
    NSMutableString *result=[[NSMutableString alloc] init];
    /*
    for (UIView *v in [self.tableView subviews]) {
        if ([v isKindOfClass:[UITableViewCell class]]){
            UITableViewCell *cell = (UITableViewCell *)v;
            if (cell.accessoryType==UITableViewCellAccessoryCheckmark){
                [result appendString:@","];
                [result appendString:cell.textLabel.text];
            }
        }
    
    }
     */
    for(id item in _list){
        if ([item[@"checked"] isEqual:@"yes"]){
            [result appendString:@","];
            [result appendString:item[@"code"]];
        }
    }
    if ([result isEqualToString:@""]){
        [result appendString:@",C1"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"car_type" object:self userInfo:@{@"result":result}];
    if (self.delegate){
        [self.delegate setValueByKey:[result substringFromIndex:1] key:@"car_type"];
    }
    [self.navigationController popViewControllerAnimated:YES];
  
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    id item=[_list objectAtIndex:indexPath.row];
    cell.textLabel.text = item[@"code"];
    cell.detailTextLabel.text =item[@"name"];//[NSString stringWithFormat:@"年审间隔：%@年",item[@"years"]];
    //cell.accessoryType = UITableViewCellAccessoryNone;
    if ([item[@"checked"] isEqual:@"yes"]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType =UITableViewCellAccessoryNone;
    }
    //[self setupCellAccessory:cell];
    return cell;
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
    id item=[_list objectAtIndex:indexPath.row];
    UITableViewCell *cell =[self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        item[@"checked"]=@"yes";
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        item[@"checked"]=@"no";
    }
}

-(void)setup{
    _helper.url=[_helper appSetttings].url_get_license_type;
}
-(void)processData:(id)json{
    NSLog(@"%@",json);
    _list = json[@"result"];
    
    
    [self setupFilter];
    
    [self.tableView reloadData];
}

@end
