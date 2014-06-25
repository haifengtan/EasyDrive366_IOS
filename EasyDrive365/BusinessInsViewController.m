//
//  BusinessInsViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/25/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "BusinessInsViewController.h"
#import "BusinessInsuranceViewController.h"
#import "ItemDetailCell.h"
#import "Insurance4ColumnsCell.h"
#import "InsuranceFooterView.h"
#import "HttpClient.h"
#import "AppSettings.h"
#import "PhoneView.h"


@interface BusinessInsViewController (){
    NSMutableArray *_list;
    id _curr;
    id _renew;
    id _price;
    NSMutableArray *_sectionHeaders;
}

@end

@implementation BusinessInsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    _curr = nil;
    _price = nil;
    _renew = nil;
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _list = [[NSMutableArray alloc] init];
    _sectionHeaders =[[NSMutableArray alloc] init];
    [[HttpClient sharedHttp] get:[AppSettings sharedSettings].url_get_count_of_suggestions block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            
            NSNumber *count = json[@"result"];
            if ([count intValue]>0){
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"报价" style:UIBarButtonSystemItemAction target:self action:@selector(suggestBusiness:)];
            }else{
                
            }
            
        }else{
            //get nothing from server;
        }
    }];
    [self setupTableView:self.tableView];
    
}
-(void)setup{
    _helper.url=[_helper appSetttings].url_get_business_insurance;
}
-(void)processData:(id)json{
    [_list removeAllObjects];
    _company = json[@"result"][@"company"];
    _phone = json[@"result"][@"phone"];
    NSLog(@"%@",json[@"result"]);
    id result = json[@"result"][@"data"];
    _curr=[self parseData:result key:@"curr"];
    NSNumber *total = result[@"renew"][@"total"];
    if ([total intValue]>0){
        _renew=[self parseData:result key:@"renew"];
    }else{
        _renew=nil;
    }
    if (result[@"pricelist"]){
        total =result[@"pricelist"][@"total"];
        if ([total intValue]>0){

            _price=[self parseData:result key:@"pricelist"];
        }else{
           
            _price = nil;
        }
    }
    NSLog(@"%@",_list);
    [self.tableView reloadData];
    [self endRefresh:self.tableView];
    
}
-(void)responseError:(id)json{
    [self endRefresh:self.tableView];
}
-(id)parseData:(id)result key:(NSString *)key{
    id curr = result[key];
    /*
    NSMutableArray *sum=[[NSMutableArray alloc] init];
    [sum addObject:@{@"name":@"商业险",@"price":[NSString stringWithFormat:@"%@",curr[@"biz"]]}];
    [sum addObject:@{@"name":@"车船税",@"price":[NSString stringWithFormat:@"%@",curr[@"tax"]]}];
    [sum addObject:@{@"name":@"交强险",@"price":[NSString stringWithFormat:@"%@",curr[@"com"]]}];
    [sum addObject:@{@"name":@"合计",@"price":[NSString stringWithFormat:@"%@",curr[@"total"]]}];
     */
    NSMutableArray *items=[[NSMutableArray alloc] init];
    for (id item in curr[@"list"]) {
        [items addObject:item];
    }
    
    //[_list addObject:sum];
    [_list addObject:items];
    [_sectionHeaders addObject:curr];
    return curr;
}
-(void)parseData_old:(id)result key:(NSString *)key{
    id curr = result[key];
    NSMutableArray *sum=[[NSMutableArray alloc] init];
    [sum addObject:@{@"name":@"商业险",@"price":[NSString stringWithFormat:@"%@",curr[@"biz"]]}];
    [sum addObject:@{@"name":@"车船税",@"price":[NSString stringWithFormat:@"%@",curr[@"tax"]]}];
    [sum addObject:@{@"name":@"交强险",@"price":[NSString stringWithFormat:@"%@",curr[@"com"]]}];
    [sum addObject:@{@"name":@"合计",@"price":[NSString stringWithFormat:@"%@",curr[@"total"]]}];
    NSMutableArray *items=[[NSMutableArray alloc] init];
    for (id item in curr[@"list"]) {
        [items addObject:item];
    }
    //id section=@{@"sum":sum,@"items":items};
    [_list addObject:sum];
    [_list addObject:items];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_list count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_list objectAtIndex:section] count];
    /*if (section==1 || section==3){
        return [[_list objectAtIndex:section] count]+1;
    }else{
        return [[_list objectAtIndex:section] count];
    }
     */
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    /*
    if (section==0){
        return @"当前保单";
    }else {
        return @"新续保单";
    }
     */
    return [_sectionHeaders objectAtIndex:section][@"title"];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier2 = @"cell2";
    Insurance4ColumnsCell *cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
    if (cell==nil){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"Insurance4ColumnsCell" owner:nil options:nil] objectAtIndex:0];
    }
    /*
    if (indexPath.row==0){
        
        cell.nameLabel.text = @"";
        cell.item1Label.text= @"保额";
        cell.item2Label.text =@"保费";
        cell.item3Label.text = @"不计免赔";
        
    }else{
        id item=[[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.nameLabel.text = item[@"InsuName"];
        cell.item1Label.text= [NSString stringWithFormat:@"%@",item[@"Amount"]];
        cell.item2Label.text =[NSString stringWithFormat:@"%@",item[@"Fee"]];
        cell.item3Label.text = [NSString stringWithFormat:@"%@",item[@"DeductibleFee"]];
    }
    */
    id item=[[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.nameLabel.text = item[@"InsuName"];
    cell.item1Label.text= [NSString stringWithFormat:@"%@",item[@"Amount"]];
    cell.item2Label.text =[NSString stringWithFormat:@"%@",item[@"Fee"]];
    cell.item3Label.text = [NSString stringWithFormat:@"%@",item[@"DeductibleFee"]];
    return cell;
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
-(void)suggestBusiness:(id)sender{
    BusinessInsuranceViewController *vc= [[BusinessInsuranceViewController alloc] initWithNibName:@"BusinessInsuranceViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    id dict;
    /*
    if (section==0){
        dict = _curr;
    }else if (section==1){
        dict = _renew;
        
        
    }else{
        dict = _price;
    }*/
    dict = [_sectionHeaders objectAtIndex:section];
    InsuranceFooterView *fv = [[[NSBundle mainBundle] loadNibNamed:@"InsuranceFooterView" owner:nil options:nil] objectAtIndex:0];
    fv.backgroundColor = [self.tableView backgroundColor];
    fv.summaryLabel.text=[NSString stringWithFormat:@"%@",dict[@"total"]];
    fv.companyLabel.text=[NSString stringWithFormat:@"%@",dict[@"company"]];//@"平安保险";
    fv.noLabel.text=[NSString stringWithFormat:@"%@",dict[@"po"]];//@"ADS9232749878989SDFSDF";
    fv.dateLabel.text=[NSString stringWithFormat:@"%@",dict[@"valid"]];//@"2012-10-21 至 2013-10-20 止";
    return fv;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 140;
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
@end
