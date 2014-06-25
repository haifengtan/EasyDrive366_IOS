//
//  TaxForCarShipViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/14/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "TaxForCarShipViewController.h"
#import "PhoneView.h"


@interface TaxForCarShipViewController (){
    NSMutableArray *_listType;
    NSMutableArray *_listItems;
    NSMutableArray *_listRemarks;
    
}

@end

@implementation TaxForCarShipViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [_listType count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [[_listItems objectAtIndex:section] count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_listType objectAtIndex:section];
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return [_listRemarks objectAtIndex:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    NSArray *items =[_listItems objectAtIndex:indexPath.section];
    id item =[items objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [item objectForKey:@"description"];
    cell.detailTextLabel.text = [item objectForKey:@"price"];
  
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0){
        PhoneView *phoneView = [[[NSBundle mainBundle] loadNibNamed:@"PhoneView" owner:nil options:nil] objectAtIndex:0];
        [phoneView initWithPhone:_company phone:_phone];
        phoneView.backgroundColor = tableView.backgroundColor;
        return phoneView;
    }else{
        return nil;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section==0)
        return 80;
    else
        return 22;
}

-(void)setup{
    _helper.url=[NSString stringWithFormat:@"api/get_taxforcarship?userid=%d",[_helper appSetttings].userid];
}
-(void)processData:(id)json{
    NSLog(@"%@",json);
    _company = json[@"result"][@"company"];
    _phone = json[@"result"][@"phone"];
    _listType = [[NSMutableArray alloc] init];
    _listItems =[[NSMutableArray alloc] init];
    _listRemarks =[[NSMutableArray alloc] init];
    NSMutableDictionary *result = json[@"result"][@"data"];
    NSArray *allKeys =[result allKeys];
    
    NSArray *newList =[allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *s1 = obj1;
        NSString *s2 = obj2;
        return [s1 compare:s2];
    }];
    for(int i=0;i<[newList count];i++){
        NSString *key =[newList objectAtIndex:i];
        [_listType addObject:key];
        [_listItems addObject:result[key][@"list"]];
        [_listRemarks addObject:result[key][@"marks"]];
    }
    /*
    NSEnumerator *enumerator= [result keyEnumerator];
    id key;
    while (key=[enumerator nextObject]) {
        NSLog(@"%@",key);
        [_listType addObject:key];
        [_listItems addObject:result[key][@"list"]];
        [_listRemarks addObject:result[key][@"marks"]];
    }
     */
    [self.tableView reloadData];
    [_refreshHelper endRefresh:self.tableView];
}
@end
