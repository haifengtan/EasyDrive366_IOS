//
//  BrandSelectController.m
//  EasyDrive366
//
//  Created by Steven Fu on 4/14/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "BrandSelectController.h"
#import "BrandItemCell.h"


@interface BrandSelectController (){
    id _selected;
}

@end

@implementation BrandSelectController

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
    self.title= @"品牌选择";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(finishSelected)];

}
-(void)finishSelected{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:SELECTED_BRAND object:nil userInfo:_selected];
 
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCellBrandItem"];
    if (cell==nil){
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BrandItemCell" owner:nil options:nil] objectAtIndex:0];
    }
    BrandItemCell *aCell = (BrandItemCell *)cell;
    id item = [_list objectAtIndex:indexPath.row];
    aCell.lblBrand.text =item[@"brand"];
    aCell.lblBrand_id.text = item[@"brand_id"];
    aCell.lblExhause.text =[NSString stringWithFormat:@"排量：%@", item[@"exhause"]];
    aCell.lblModel.text =item[@"model"];
    aCell.lblPassengers.text = [NSString stringWithFormat:@"乘客：%@", item[@"passengers"]];
    aCell.lblPrice.text = [NSString stringWithFormat:@"价格：%@", item[@"price"]];
    
    if ([item[@"brand"] isEqualToString:self.brand] && [item[@"brand_id"] isEqualToString:self.brand_id]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        _selected = item;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    _selected = [_list objectAtIndex:indexPath.row];
    self.brand_id = _selected[@"brand_id"];
    self.brand = _selected[@"brand"];
    [self.tableView reloadData];
}


@end
