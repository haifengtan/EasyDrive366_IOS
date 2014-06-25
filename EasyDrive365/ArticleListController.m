//
//  ArticleListController.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/12/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ArticleListController.h"
#import "ArticleListItemCell.h"
#import "UIImageView+AFNetworking.h"
#import "GoodsCategoryController.h"
#import "ProviderDetailController.h"
#import "DetailPictureCell.h"

#import "ArticleListItem2Cell.h"
#import "Browser2Controller.h"

@interface ArticleListController (){
    id _list;
    id _imageList;
    UIImageView *_imageView;
    UIPageControl *_pager;
    int _index;
}

@end

@implementation ArticleListController

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
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goLeft)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:swipeLeft];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goRight)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:swipeRight];
    
}

-(void)showPicture:(int)i{
    NSString *url = [_imageList objectAtIndex:i][@"pic_url"];
    [_imageView setImageWithURL:[NSURL URLWithString:url]];
    _pager.currentPage = i;
}

-(void)goRight{
    _index--;
    if (_index<0){
        _index =[_imageList count]-1;
        
    }
    [self showPicture:_index];
}
-(void)goLeft{
    _index++;
    if (_index>[_imageList count]-1){
        _index=0;
    }
    [self showPicture:_index];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setup{
    if (self.isSearch){
        NSString *t;
        if ([self.searchTypes hasSuffix:@","]){
            t = [self.searchTypes substringToIndex:[self.searchTypes length]-1];
        }else{
            t = self.searchTypes;
        }
        _helper.url = [NSString stringWithFormat:@"library/get_list?userid=%d&type=%@&keyword=%@",[AppSettings sharedSettings].userid,t,self.searchKey?self.searchKey:@""];
        self.title = @"百科查询";
    }else{
        _helper.url = [NSString stringWithFormat:@"library/get_list?userid=%d",[AppSettings sharedSettings].userid];
        self.title = @"百科";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分类" style:UIBarButtonSystemItemAction target:self action:@selector(openCategory)];
    }
    
    
}
-(void)processData:(id)json{
    _list = json[@"result"][@"data"];
    _imageList = json[@"result"][@"album"];
    [self.tableView reloadData];
    [_refreshHelper endRefresh:self.tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0){
        return 1;
    }
    return [_list count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (indexPath.section==0){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailPictureCell" owner:nil options:nil] objectAtIndex:0];
        DetailPictureCell *aCell = (DetailPictureCell *)cell;
        [aCell.image setImageWithURL:[NSURL URLWithString:[_imageList objectAtIndex:0 ][@"pic_url"]]];
        aCell.pager.numberOfPages =[ _imageList count];
        _imageView = aCell.image;
        _pager = aCell.pager;
    }else{
        
        if (cell==nil){
            cell= [[[NSBundle mainBundle] loadNibNamed:@"ArticleListItemCell" owner:nil options:nil] objectAtIndex:0];
        }
        id item = [_list objectAtIndex:indexPath.row];
        ArticleListItemCell *itemCell=(ArticleListItemCell *)cell;
        itemCell.lblTitle.text =item[@"title"];
        itemCell.lblDescription.text = item[@"description"];
        
        itemCell.lblVoternum.text =[NSString stringWithFormat:@"%@", item[@"star_voternum"]];
        itemCell.rating = [item[@"star_num"] intValue];
         [itemCell.image setImageWithURL:[NSURL URLWithString:item[@"pic_url"]]];
        itemCell.share_data = item;
        [itemCell.image setImageWithURL:[NSURL URLWithString:item[@"pic_url"]]];
        if ([item[@"is_favor"] intValue]==1){
            [itemCell.favorbtn setImage:[UIImage imageNamed:@"favor"] forState:UIControlStateNormal];
        }else{
            [itemCell.favorbtn setImage:[UIImage imageNamed:@"favorno"] forState:UIControlStateNormal];
        }
        itemCell.parent = self.navigationController;
        /*
        if (cell==nil){
            cell= [[[NSBundle mainBundle] loadNibNamed:@"ArticleListItem2Cell" owner:nil options:nil] objectAtIndex:0];
        }
        id item = [_list objectAtIndex:indexPath.row];
        ArticleListItem2Cell *itemCell=(ArticleListItem2Cell *)cell;
        itemCell.lblTitle.text =item[@"title"];
        itemCell.lblDescription.text = item[@"description"];
        itemCell.share_data = item;
        [itemCell.image setImageWithURL:[NSURL URLWithString:item[@"pic_url"]]];
        if (indexPath.row % 2==0){
            [itemCell.favorbtn setBackgroundImage:[UIImage imageNamed:@"favor"] forState:UIControlStateNormal];
        }else{
                        [itemCell.favorbtn setBackgroundImage:[UIImage imageNamed:@"favorno"] forState:UIControlStateNormal];
        }
         */
    }
    
    return  cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0){
        return 150.0f;
        
    }
    return 120.0f;
    //return 85.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1){
        id item = [_list objectAtIndex:indexPath.row];
        NSString *url = item[@"url"];
        
        /*
        BrowserViewController *vc = [[BrowserViewController alloc] initWithNibName:@"BrowserViewController" bundle:nil];
        vc.title = item[@"title"];
//        vc.url  = url;
        [self.navigationController pushViewController:vc animated:NO];
        [vc go:url];
        */
        Browser2Controller *vc = [[Browser2Controller alloc] initWithNibName:@"Browser2Controller" bundle:nil];
        vc.url = url;
        vc.title = item[@"title"];
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
    }else if (indexPath.section==0){
        id item = [_imageList objectAtIndex:_pager.currentPage];
        //NSLog(@"%@",item);

        Browser2Controller *vc = [[Browser2Controller alloc] initWithNibName:@"Browser2Controller" bundle:nil];
        vc.url = item[@"url"];

        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

-(void)openCategory{
    GoodsCategoryController *vc = [[GoodsCategoryController alloc] initWithStyle:UITableViewStylePlain];
    vc.type=@"article";
    [self.navigationController pushViewController:vc animated:YES];
}



@end
