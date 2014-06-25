//
//  CarHelpViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 5/9/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "CarHelpViewController.h"
#import "ItemDetailCell.h"
#import "PhoneView.h"
#import "CarHelpTabController.h"


@interface CarHelpViewController (){
     NSMutableArray *_list;
}

@end

@implementation CarHelpViewController

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
    [self setupTableView:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}


-(void)setup{
    _helper.url = [AppSettings sharedSettings].url_for_get_check_helpcalls;
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
    
    [self endRefresh:self.tableView];
    
    
}
-(void)responseError:(id)json{
    [self endRefresh:self.tableView];
}
-(void)updateData{
    
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _list?[_list count]:0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentitifier=@"Cell";
    ItemDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentitifier];
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _company;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CarHelpTabController *vc = [[CarHelpTabController alloc] init];
    //ServiceNoteViewController *vc =[[ServiceNoteViewController alloc] initWithNibName:@"ServiceNoteViewController" bundle:nil];
    id item = [_list objectAtIndex:indexPath.row];
    vc.code = item[@"Code"];
    vc.pageId = @"12";
    [self.navigationController pushViewController:vc animated:YES];
}
@end
