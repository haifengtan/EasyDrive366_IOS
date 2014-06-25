//
//  ArticleCommentViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 6/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ArticleCommentViewController.h"
#import "AppSettings.h"
#import "CommentCell.h"
#import "AddCommentViewController.h"

@interface ArticleCommentViewController (){
    id _list;
}

@end

@implementation ArticleCommentViewController

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
    self.title = @"用户评论";
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"发表评论" style:UIBarButtonSystemItemAdd target:self action:@selector(add_comment)];
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
    _helper.url =[NSString stringWithFormat:@"article/get_review?user_id=%d&column_id=%@&article_id=%@",
                  [AppSettings sharedSettings].userid,
                  _article[@"column_id"],
                  _article[@"id"]];
    
}
-(void)processData:(id)json{
    NSLog(@"%@",json);
    _list = json[@"result"];
    [self.tableView reloadData];
    [self endRefresh:self.tableView];
}
-(void)responseError:(id)json{
    [self endRefresh:self.tableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_list count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"tableCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil){
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:nil options:nil] objectAtIndex:0];
    }
    id item = [_list objectAtIndex:indexPath.row];
    cell.lblUser.text = [NSString stringWithFormat:@"%@发布于%@",item[@"user_name"],item[@"fmt_create_time"]];
    
    ;
    cell.lblContent.text = [NSString stringWithFormat:@"%@(%d个字)",item[@"content"],[item[@"content"] length]];
    return  cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160.0f;
}
-(void)add_comment{
    AddCommentViewController *vc =[[AddCommentViewController alloc] initWithNibName:@"AddCommentViewController" bundle:nil];
    vc.article = self.article;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
