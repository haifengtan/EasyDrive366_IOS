//
//  ItemCommentsController.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/18/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ItemCommentsController.h"
#import "AppSettings.h"
#import "CommentListCell.h"
#import "CommentItemCell.h"
#import "DoCommentController.h"

@interface ItemCommentsController (){
    id _list;
    id _json;
}

@end

@implementation ItemCommentsController

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
    self.title = @"评论详情";
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"评论" style:UIBarButtonSystemItemAction target:self action:@selector(addComment)];
    [self load_data];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"返回"
                                     style:UIBarButtonItemStyleBordered
                                    target:self action:@selector(goBack)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(load_data) name:ADD_COMMENT_SUCCESS object:Nil];
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)load_data{
    NSString* url = [NSString stringWithFormat:@"comment/get_comment?userid=%d&type=%@&id=%@",[AppSettings sharedSettings].userid,self.itemType,self.itemId];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        _json = json[@"result"];
        _list = json[@"result"][@"list"];
        [self.tableView reloadData];
    }];
    
}
-(void)addComment{
    DoCommentController *vc =[[DoCommentController alloc] initWithNibName:@"DoCommentController" bundle:nil];
    vc.item_id = self.itemId;
    vc.item_type = self.itemType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
        return 1;
    return [_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell ;
    if (indexPath.section==0){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentItemCell" owner:nil options:nil] objectAtIndex:0];
        CommentItemCell *aCell = (CommentItemCell *)cell;
        id stars = _json[@"stars_info"];
        aCell.lblAvg_stars.text = [NSString stringWithFormat:@"%@",_json[@"avg_star"]];
        aCell.lblVoter_num.text = [NSString stringWithFormat:@"%@",_json[@"total_voters"]];
        aCell.rating = [_json[@"avg_star"] intValue];
        [aCell.pvStar1 setProgress:[stars[@"1"][@"percent"] floatValue]];
        aCell.lblStar1.text = [NSString stringWithFormat:@"%@",stars[@"1"][@"count"]];
        
        [aCell.pvStar2 setProgress:[stars[@"2"][@"percent"] floatValue]];
        aCell.lblStar2.text = [NSString stringWithFormat:@"%@",stars[@"2"][@"count"]];
        [aCell.pvStar3 setProgress:[stars[@"3"][@"percent"] floatValue]];
        aCell.lblStar3.text = [NSString stringWithFormat:@"%@",stars[@"3"][@"count"]];
        [aCell.pvStar4 setProgress:[stars[@"4"][@"percent"] floatValue]];
        aCell.lblStar4.text = [NSString stringWithFormat:@"%@",stars[@"4"][@"count"]];
        [aCell.pvStar5 setProgress:[stars[@"5"][@"percent"] floatValue]];
        aCell.lblStar5.text = [NSString stringWithFormat:@"%@",stars[@"5"][@"count"]];
        
        
    }else{
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentListCell" owner:nil options:nil] objectAtIndex:0];
        CommentListCell *aCell = (CommentListCell *)cell;
        id item =[_list objectAtIndex:indexPath.row];
        aCell.lblUsername.text = item[@"username"];
        aCell.lblDate.text = item[@"submit_time"];
        aCell.lblComment.text = item[@"comment"];
        aCell.rating = [item[@"star"] intValue];
        NSLog(@"%@",item);
    }
    
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0){
        return  120.0f;
    }else{
        return 60.0f;
    }
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
