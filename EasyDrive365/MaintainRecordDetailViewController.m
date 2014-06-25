//
//  MaintainRecordDetailViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/14/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "MaintainRecordDetailViewController.h"

@interface MaintainRecordDetailViewController (){
    NSMutableArray *_list;
}

@end

@implementation MaintainRecordDetailViewController

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
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    
}


-(void)setData:(id)data{
    self.txtCompany.text = [data objectForKey:@"company"];
    self.txtDate.text =[data objectForKey:@"date"];
    self.txtIssue.text =[data objectForKey:@"issue"];
    if (_list){
        [_list removeAllObjects];
    }else{
        _list =[[NSMutableArray alloc] init];
    }
    [_list addObjectsFromArray:[data objectForKey:@"items"]];
    [self.tableview reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtDate:nil];
    [self setTxtIssue:nil];
    [self setTxtCompany:nil];
    [self setTableview:nil];
    [super viewDidUnload];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _list?[_list count]:0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentitifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentitifier];
    if (cell == nil){
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentitifier];
        
    }
    id item = [_list objectAtIndex:indexPath.row];
    
    cell.textLabel.text=[item objectForKey:@"item"];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@", [item objectForKey:@"price"]];
    return cell;

}
@end
