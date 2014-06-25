//
//  InsuranceStep4Controller.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/27/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "InsuranceStep4Controller.h"
#import "AppSettings.h"
#import "InsuranceStep5Controller.h"

@interface InsuranceStep4Controller ()<UIActionSheetDelegate>{
    id _list;
    int _index;
    UIView *_headerView;
    UISegmentedControl *_segment;
    id _currentItem;

}

@end

@implementation InsuranceStep4Controller

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

    self.title = @"第四步";
 
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonSystemItemAction target:self action:@selector(backTo)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonSystemItemAction target:self action:@selector(confirm)];
    _index=0;
    for (id list in self.insurance_data) {
        for (id item in list[@"clause"]) {
            item[@"subindex"]=@"-1";
            item[@"origin_value"]=item[@"amount"];
        }
    }
    [self load_data];
}
-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)confirm{
    
    NSMutableArray *parameters = [[NSMutableArray alloc] initWithCapacity:[_list count]];
    for (id item in _list) {
        NSLog(@"%@=%@|%@",item[@"insu_code"],item[@"amount"],item[@"is_enabled"]);
        [parameters addObject:[NSString stringWithFormat:@"%@=%@|%@",item[@"insu_code"],item[@"amount"],item[@"is_enabled"]]];
    }
    NSString *url = [NSString stringWithFormat:@"ins/carins_total?userid=%d&%@",[AppSettings sharedSettings].userid,[parameters componentsJoinedByString:@"&"]];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            NSLog(@"%@",json);
            InsuranceStep5Controller *vc = [[InsuranceStep5Controller alloc] initWithStyle:UITableViewStyleGrouped];
            vc.insurance_data = json[@"result"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)load_data{
    _list = [self.insurance_data objectAtIndex:_index][@"clause"];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!_headerView){
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        _headerView.backgroundColor =[UIColor clearColor];
        NSMutableArray *items = [[NSMutableArray alloc] init];
        for (id c in self.insurance_data) {
            [items addObject:c[@"title"]];
        }
        _segment= [[UISegmentedControl alloc] initWithItems:items];
        _segment.frame = CGRectMake(10, 5, 300, 40);

        [_segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
        [_headerView addSubview:_segment];

    }
    [_segment setSelectedSegmentIndex:_index];
    return _headerView;
}
-(void)segmentChanged:(UISegmentedControl *)sender{
    _index = sender.selectedSegmentIndex;
    [self load_data];
    [self.tableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
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
    
    cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    id item = [_list objectAtIndex:indexPath.row];
    cell.textLabel.text = item[@"insu_name"];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%0.2f", [item[@"amount"] floatValue]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 105, 24)];
    label.text =[NSString stringWithFormat:@"¥%0.2f", [item[@"amount"] floatValue]];
    label.textAlignment = NSTextAlignmentRight;
    label.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:label];

    CGRect rect;
    if ([[AppSettings sharedSettings] isIos7]){
        rect =  CGRectMake(240, 10, 50, 24);
    }else{
        rect = CGRectMake(200, 10, 50, 24);
    }

    UISwitch *sw = [[UISwitch alloc] initWithFrame:rect];
    sw.on = [item[@"is_enabled"] intValue]==1;
    sw.tag = indexPath.row;
    [sw addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [cell.contentView addSubview:sw];
    if ([item[@"amount_list"] count]>0){
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
-(void)switchChanged:(UISwitch *)sw{
    int index = sw.tag;
    id item = [_list objectAtIndex:index];
    item[@"is_enabled"]=sw.isOn?@"1":@"0";
    if (!sw.isOn){
        item[@"origin_value"]=item[@"amount"];
        item[@"amount"]=@0.0;
    }else{
        item[@"amount"]=item[@"origin_value"];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    //UITableViewCell *cell= [self.tableView cellForRowAtIndexPath:indexPath];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath]  withRowAnimation:UITableViewRowAnimationFade];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _currentItem= [_list objectAtIndex:indexPath.row];
    CGFloat amount = [_currentItem[@"amount"] floatValue];
    id list = _currentItem[@"amount_list"];
    if ([list count]>0){
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:Nil delegate:self cancelButtonTitle:Nil destructiveButtonTitle:nil otherButtonTitles:nil];
        int selectedIndex = -1;
        for (int i=0;i<[list count];i++) {
            id l = list[i];
            [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%@",l[@"label"]]];
            if (amount == [l[@"value"] floatValue]){
                selectedIndex =i;
            }
        }
        [actionSheet addButtonWithTitle:@"取消"];
        [actionSheet setCancelButtonIndex:[list count]];
        if (selectedIndex>-1){
            [actionSheet setDestructiveButtonIndex:selectedIndex];
        }
        //[actionSheet showInView:self.view];
        [actionSheet showFromTabBar:[[AppSettings sharedSettings] tabBarController].tabBar];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"clicked on %d",buttonIndex);
    id list = _currentItem[@"amount_list"];
    if (buttonIndex<[list count]){
        id item = [list objectAtIndex:buttonIndex];
        _currentItem[@"amount"]=item[@"value"];
        [self.tableView reloadData];
        _currentItem[@"is_enabled"] = @"1";
    }
}
@end
