//
//  HelpCallViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "HelpCallViewController.h"
#import "HelpHeaderView.h"
#import "ItemDetailCell.h"
#import "PhoneView.h"
#import "AppSettings.h"
#import "CarHelpTabController.h"

@interface HelpCallViewController (){
    NSMutableArray *_list;
   
}

@end

@implementation HelpCallViewController

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
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Phone" style:UIBarButtonSystemItemAction target:self action:@selector(makeCall:)];
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



-(void)setup{
    if (self.taskid>0)
        _helper.url =[NSString stringWithFormat:@"%@&taskid=%d", [AppSettings sharedSettings].url_for_get_helpcalls,self.taskid];
    else
            
        _helper.url = [AppSettings sharedSettings].url_for_get_helpcalls;
}
-(void)processData:(id)json{
    
    id result =[json objectForKey:@"result"];
    NSLog(@"%@",result);
    _company = [result objectForKey:@"company"];
    _phone =[result objectForKey:@"phone"];
    
    id list = [[json objectForKey:@"result"] objectForKey:@"data"];
    if (_list){
        [_list removeAllObjects];
    }else{
        _list =[[NSMutableArray alloc] init];
    }
    if ([list isKindOfClass:[NSArray class]]){
        [_list addObjectsFromArray:list];
        [self updateData];
    }
    
    [self endRefresh:self.tableview];
    
    
}
-(void)responseError:(id)json{
    [self endRefresh:self.tableview];
}
-(void)updateData{
    
    [self.tableview reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _list?[_list count]:0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentitifier=@"Cell";
    ItemDetailCell *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIdentitifier];
    if (cell==nil){
        //cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentitifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ItemDetailCell" owner:nil options:nil] objectAtIndex:0];
    }

    id item = [_list objectAtIndex:indexPath.row];
    cell.titleLabel.text =[NSString stringWithFormat:@"%@",[item objectForKey:@"name"]];
    cell.detailLabel.text =[item objectForKey:@"description"];
    //cell.priceLabel.text= [NSString stringWithFormat:@"%@",item[@"price"]];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@",item[@"price"]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
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
    return 80;
}
/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HelpHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"HelpHeaderView" owner:nil options:nil] objectAtIndex:0];
    header.titleLabel.text= _company;
    header.detailLabel.text= _phone;
    header.backgroundColor =self.tableview.backgroundColor;
    return header;
}
 
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}
 */
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _company;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CarHelpTabController *vc = [[CarHelpTabController alloc] init];
    //ServiceNoteViewController *vc =[[ServiceNoteViewController alloc] initWithNibName:@"ServiceNoteViewController" bundle:nil];
    id item = [_list objectAtIndex:indexPath.row];
    vc.code = item[@"Code"];
    vc.pageId = @"02";
    [self.navigationController pushViewController:vc animated:YES];
}
@end
