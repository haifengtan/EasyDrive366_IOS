//
//  IncomingViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 5/9/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "IncomingViewController.h"
#import "AppSettings.h"
#import "ItemDetailCell.h"
#import "ArticleController.h"

@interface IncomingViewController (){
    id _data;
}

@end

@implementation IncomingViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setup{
    _helper.url =[NSString stringWithFormat:@"article/get_article_list?user_id=%d&column_id=%@%@2",
                  [AppSettings sharedSettings].userid,
                  self.pageId,self.code];
    
}
-(void)processData:(id)json{
    NSLog(@"%@",json);
    _data = json[@"result"];
    [self.tableView reloadData];
}
-(void)responseError:(id)json{
    [self endRefresh:self.tableView];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_data count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_data objectAtIndex:section][@"article"] count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_data objectAtIndex:section][@"catalog_name"];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"tableCell";
    ItemDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil){
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ItemDetailCell" owner:nil options:nil] objectAtIndex:0];
    }
    id item = [[_data objectAtIndex:indexPath.section][@"article"] objectAtIndex:indexPath.row];
    cell.titleLabel.text =item[@"title"];
    cell.detailLabel.text = item[@"summary"];
    cell.dateLabel.text = item[@"fmt_update_time"];
    cell.priceLabel.text = item[@"author"];
    return  cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = [[_data objectAtIndex:indexPath.section][@"article"] objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:OPEN_ARTICLE object:nil userInfo:item];
}
@end
