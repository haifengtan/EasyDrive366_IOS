//
//  IllegallyListViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "IllegallyListViewController.h"
#import "HttpClient.h"
#import "AppSettings.h"
#import "RecordCell.h"
#import "IllegallyDetailViewController.h"
@interface IllegallyListViewController ()
{
    NSMutableArray *_list;
}
@end

@implementation IllegallyListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title =@"违章记录";
    }
    return self;
}

- (void)viewDidLoad
{
    _reloadDirectly = NO;
    [super viewDidLoad];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [self setupTableView:self.tableview];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableview:nil];
    [super viewDidUnload];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list?[_list count]:0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentitifier = @"Cell";
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentitifier];
    if (cell == nil){
        //cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentitifier];
        cell =[[[NSBundle mainBundle] loadNibNamed:@"RecordCell" owner:nil options:nil] objectAtIndex:0];
        
    }
    id item = [_list objectAtIndex:indexPath.row];
    
    cell.titleLabel.text=[item objectForKey:@"Address"];
    cell.descriptionLabel.text=[item objectForKey:@"Reason"];
    cell.dateLabel.text = item[@"OccurTime"];
    cell.pointLabel.text= item[@"Mark"];
    cell.moneyLabel.text = item[@"Fine"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

-(void)setup{
    
    _helper.url = [AppSettings sharedSettings].url_for_illegallys;
}
-(void)processData:(id)json{
    if (_list){
        [_list removeAllObjects];
    }else{
        _list =[[NSMutableArray alloc] init];
    }
    [_list addObjectsFromArray:[json objectForKey:@"result"][@"data"]];
    NSLog(@"%@",_list);
    [self.tableview reloadData];
    [self endRefresh:self.tableview];
}
-(void)responseError:(id)json{
    [self endRefresh:self.tableview];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item =[_list objectAtIndex:indexPath.row];
    NSString *url = [NSString stringWithFormat:@"api/get_illegally?userid=%d&id=%@",
                     [AppSettings sharedSettings].userid,
                     item[@"id"]];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            NSLog(@"%@",json);
            NSString *address = json[@"result"][@"data"][@"Address"];
            if (![address isEqualToString:@""]){
                IllegallyDetailViewController *vc = [[IllegallyDetailViewController alloc] initWithNibName:@"IllegallyDetailViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
                vc.lblAddress.text = address;
                vc.lblContent.text = json[@"result"][@"data"][@"Reason"];
                vc.lblTitle.text=[NSString stringWithFormat:@"%@ 罚款%@扣%@",
                                  json[@"result"][@"data"][@"OccurTime"],
                                  json[@"result"][@"data"][@"Fine"],
                                  json[@"result"][@"data"][@"Mark"]];
            }
        }
        
        
    }];
    
}
@end
