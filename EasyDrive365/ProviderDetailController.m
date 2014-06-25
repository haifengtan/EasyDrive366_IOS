//
//  ProviderDetailController.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/11/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ProviderDetailController.h"
#import "AppSettings.h"
#import "ProviderListItemCell.h"
#import "DetailPictureCell.h"
#import "DetailRateCell.h"
#import "UIImageView+AFNetworking.h"
#import "ItemCommentsController.h"
#import "ImageInfoCell.h"
#import "ShowLocationViewController.h"
#import "GoodsListItemCell.h"
#import "NewOrderController.h"
#import "GoodsDetailController.h"
#import "Browser2Controller.h"

@interface ProviderDetailController ()<UIActionSheetDelegate,BuyButtonDelegate>{
    id _target;
    UIImageView *_imageView;
    UIPageControl *_pager;
    int _index;
    UIView *_navigationView;
    UIButton *_favorBtn;
}

@end

@implementation ProviderDetailController

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
    if (self.name)
        self.title = self.name;

    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goLeft)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:swipeLeft];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goRight)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:swipeRight];
    

    
}

-(void)showPicture:(int)i{
    NSString *url = [_target[@"album"] objectAtIndex:i][@"pic_url"];
    //[_imageView setImageWithURL:[NSURL URLWithString:url]];
    [_imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_640x234.png"]];
    _pager.currentPage = i;
}

-(void)goRight{
    _index--;
    if (_index<0){
        _index =[_target[@"album"] count]-1;
        
    }
    [self showPicture:_index];
}
-(void)goLeft{
    _index++;
    if (_index>[_target[@"album"] count]-1){
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
    _helper.url = [NSString stringWithFormat:@"api/get_service_info?userid=%d&code=%@",[AppSettings sharedSettings].userid,self.code];
    
}
-(void)processData:(id)json{
    if ([[AppSettings sharedSettings] isSuccess:json]){
        _target = json[@"result"];
        _index=0;
        NSLog(@"%@",_target);
        [self.tableView reloadData];
        [_refreshHelper endRefresh:self.tableView];
        [self addRightButtons];
    }
    
}
-(void)addRightButtons{
    NSString *imageName = [_target[@"is_favor"] intValue]==1?@"shoucang":@"quxiaosc";
    if (!_navigationView){
        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        
        _favorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _favorBtn.frame = CGRectMake(30, 2, 30, 30);
        [_favorBtn addTarget:self action:@selector(addFavor) forControlEvents:UIControlEventTouchUpInside];
        //[_favorBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [_navigationView addSubview:_favorBtn];
        
        
        UIButton *exampleButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        exampleButton2.frame = CGRectMake(70, 2, 30, 30);
        [exampleButton2 addTarget:self action:@selector(goShare) forControlEvents:UIControlEventTouchUpInside];
        [exampleButton2 setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
        
        [_navigationView addSubview:exampleButton2];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_navigationView];
    }
    [_favorBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
}
-(void)addFavor{
    if ([_target[@"is_favor"] intValue]==0){
        NSString *url = [NSString stringWithFormat:@"favor/add?userid=%d&id=%@&type=SPV",[AppSettings sharedSettings].userid,_target[@"code"]];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                [_favorBtn setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
                [_navigationView setNeedsLayout];
                _target[@"is_favor"]=@"1";
                
            }
        }];
    }else{
        NSString *url = [NSString stringWithFormat:@"favor/remove?userid=%d&id=%@&type=SPV",[AppSettings sharedSettings].userid,_target[@"code"]];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                [_favorBtn setImage:[UIImage imageNamed:@"quxiaosc"] forState:UIControlStateNormal];
                [_navigationView setNeedsLayout];
                _target[@"is_favor"]=@"0";
                
            }
        }];
    }
}
-(void)goShare{
    [[AppSettings sharedSettings] popupShareMenu:_target[@"share_title"] introduce:_target[@"share_intro"] url:_target[@"share_url"]];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==6){
        return [_target[@"goods"] count];
    }else{
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.section==0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIndetifier"];
        cell.textLabel.text = _target[@"name"];
    }else if (indexPath.section==1){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailPictureCell" owner:nil options:nil] objectAtIndex:0];
        DetailPictureCell *aCell = (DetailPictureCell *)cell;
        [aCell.image setImageWithURL:[NSURL URLWithString:_target[@"pic_url"]] placeholderImage:[UIImage imageNamed:@"default_640x234.png"]];
        aCell.pager.numberOfPages =[ _target[@"album"] count];
        _imageView = aCell.image;
        _pager = aCell.pager;
        
    }else if (indexPath.section==2){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailRateCell" owner:nil options:nil] objectAtIndex:0];
        DetailRateCell *aCell = (DetailRateCell *)cell;
        aCell.lblStar.text =[NSString stringWithFormat:@"%@",  _target[@"star"]];
        aCell.lblStar_voternum.text = [NSString stringWithFormat:@"%@", _target[@"star_voternum"]];
        aCell.rating =  [_target[@"star_num"] intValue];
        
    }else if (indexPath.section==3){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ImageInfoCell" owner:nil options:nil] objectAtIndex:0];
        ImageInfoCell *aCell = (ImageInfoCell *)cell;

        aCell.lblTitle.text = _target[@"phone"];
        //aCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        aCell.imageIcon.image = [UIImage imageNamed:@"l.png"];
        
    }else if (indexPath.section==4){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ImageInfoCell" owner:nil options:nil] objectAtIndex:0];
        ImageInfoCell *aCell = (ImageInfoCell *)cell;
        aCell.lblTitle.text = _target[@"address"];
        //aCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        aCell.imageIcon.image = [UIImage imageNamed:@"k.png"];
        
    }else if (indexPath.section==6){
        id item = [_target[@"goods"] objectAtIndex:indexPath.row];
        /*
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProviderListItemCell" owner:nil options:nil] objectAtIndex:0];
        ProviderListItemCell *itemCell=(ProviderListItemCell *)cell;
        itemCell.lblName.text =item[@"name"];
        itemCell.lblAddress.text = item[@"address"];
        itemCell.lblPhone.text = item[@"phone"];
        
        [itemCell.image setImageWithURL:[NSURL URLWithString:item[@"pic_url"]]];
         */
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsListItemCell" owner:nil options:nil] objectAtIndex:0];
        GoodsListItemCell *itemCell=(GoodsListItemCell *)cell;
        itemCell.lblTitle.text =item[@"name"];
        itemCell.lblPrice.text = item[@"price"];
        itemCell.lblStand_price.text = item[@"stand_price"];
        itemCell.lblStand_price.strikeThroughEnabled = YES;
        itemCell.lblDiscount.text = item[@"discount"];
        itemCell.lblDescription.text = item[@"description"];
        itemCell.lblBuyer.text=item[@"buyer"];
        itemCell.item = item;
        itemCell.delegate = self;
        [itemCell.image setImageWithURL:[NSURL URLWithString:item[@"pic_url"]]];
    }else if (indexPath.section==5){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 10, cell.frame.size.width-40, cell.frame.size.height-10)];
        textView.text = _target[@"description"];
        [textView setEditable:NO];
        [textView setUserInteractionEnabled:NO];
        [cell addSubview:textView];
        
    }
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 44.0;
        case 1:
            return 150;
        case 2:
            return 44;
        case 3:
            return 50;
        case 4:
            return 50;
        case 6:
            return 120.0;
        case 5:
            return 80;
            
        default:
            break;
    }
    return 44.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2){
        ItemCommentsController *vc =[[ItemCommentsController alloc] initWithStyle:UITableViewStylePlain];
        vc.itemId = self.code;
        vc.itemType =@"provider";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section==3){
        //phone
        [self makeCall];
    }else if (indexPath.section==4){
        //address;
        [self showMap];
    }else if (indexPath.section==6){
        id item = [_target[@"goods"] objectAtIndex:indexPath.row];
        GoodsDetailController *vc =[[GoodsDetailController alloc] initWithStyle:UITableViewStylePlain];
        vc.target_id =[item[@"id"] intValue];
        vc.title = item[@"name"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section==5){
        Browser2Controller *vc = [[Browser2Controller alloc] initWithNibName:@"Browser2Controller" bundle:nil];
        vc.url = _target[@"intro_url"];

        
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)BuyButtonDelegate:(id)item{
    NSLog(@"%@",item);
    NewOrderController *vc = [[NewOrderController alloc] initWithStyle:UITableViewStylePlain];
    vc.product_id = [item[@"id"] intValue];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showMap{
    id item = _target[@"x"];
    if (item==nil)
        return;
    if ([item isKindOfClass:[NSNull class]])
        return;
    if ([item isEqualToString:@""])
        return;
    
    ShowLocationViewController *vc = [[ShowLocationViewController alloc] initWithNibName:@"ShowLocationViewController" bundle:nil];
    vc.isFull = NO;
    vc.target_postion = _target ;
    [self.navigationController pushViewController:vc animated:YES];
//    [vc showSingleShop:_target];
}
- (void)makeCall {
    
    if(_target[@"phone"]){
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[NSString stringWithFormat:@"拨号：%@",_target[@"phone"]],nil];
        
        //[sheet showInView:self.view];
        
        [sheet showFromTabBar:[[AppSettings sharedSettings] tabBarController].tabBar];
        
    }
    
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0){
        NSString *phoneNumber = [@"tel://" stringByAppendingString:_target[@"phone"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
    
}
@end
