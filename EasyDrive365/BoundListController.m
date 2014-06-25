//
//  BoundListController.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/19/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "BoundListController.h"
#import "AppSettings.h"
#import "BoundListCell.h"
#import "BoundHeader.h"
@interface BoundListController (){
    id _list;
    NSString *_content;
    BoundHeader *_header;
}

@end

@implementation BoundListController

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
    self.title = @"积分交易明细";
    [self load_data];
    
}
-(void)load_data{
    NSString *url;
    if (self.taskid>0)
        url = [NSString stringWithFormat:@"bound/get_bounds_his?userid=%d&taskid=%d",[AppSettings sharedSettings].userid,self.taskid];
    else
        url = [NSString stringWithFormat:@"bound/get_bounds_his?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _list =json[@"result"][@"data"];
            _content = json[@"result"][@"content"];
            [self.tableView reloadData];
            
        }
    }];
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
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BoundListCell" owner:nil options:nil] objectAtIndex:0];
    }
    id item = [_list objectAtIndex:indexPath.row];
    NSLog(@"%@",item);
    BoundListCell *aCell = (BoundListCell *)cell;
    aCell.lblBound.text = item[@"bounds"];
    aCell.lblDate.text = [AppSettings getStringDefault:item[@"from_time"] default:@""];
    aCell.lblMemo.text = item[@"from_type"];
    aCell.lblLeft.text = item[@"this_bounds"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0){
        return 100.0f;
    }
    return  0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0){
        if (!_header){
            _header =[[[NSBundle mainBundle] loadNibNamed:@"BoundHeader" owner:nil options:nil] objectAtIndex:0];
            _header.btnOK.text=@"做任务赚积分";
            _header.parent = self.navigationController;
        }
        _header.lblContent.text= _content;
        return _header;
    }
    return nil;
}



@end
