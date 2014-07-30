//
//  BrandSelectViewController.m
//  EasyDrive366
//
//  Created by admin on 14-7-29.
//  Copyright (c) 2014年 Fu Steven. All rights reserved.
//

#import "BrandSelectViewController.h"
#import "BrandItemCell.h"

@interface BrandSelectViewController (){
    id _selected;
}

@end

@implementation BrandSelectViewController

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
    // Do any additional setup after loading the view from its nib.
    self.title= @"品牌选择";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(finishSelected)];
    
    [self getData];
    
    [self.carInfotableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
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

/**
 *  获取分组后的车辆信息
 */
-(void)getData
{
    //分组后的车辆信息
    NSMutableDictionary* map=[NSMutableDictionary dictionaryWithCapacity:17];
  
    for (id item in _list) {
        id obj=[map objectForKey:item[@"brand"]];
        //如果不存在该分组 则直接插入数据，如果已经存在 则需要把之前的数据取出来然后添加新的数据
        if(obj==nil){
            NSMutableArray *list=[NSMutableArray arrayWithCapacity:17];
            [list addObject:item];
            [map setObject:list forKey:item[@"brand"]];
        }else{
            NSMutableArray *list=[map objectForKey:item[@"brand"]];
            [list addObject:item];
            [map removeObjectForKey:item[@"brand"]];
            [map setObject:list forKey:item[@"brand"]];
        }

    }
    
    NSMutableArray* rsList=[NSMutableArray arrayWithCapacity:17];
    for (NSString *key in [map allKeys]) {
        NSMutableArray* tempList=[map objectForKey:key];
        [rsList addObject:tempList];
    }

    _allCarsInfo = rsList;
    
    //tableView分组是否是折叠
    flags = [NSMutableArray arrayWithCapacity:100];
    
    for(int i=0; i<[self.allCarsInfo count]; i++)
    {
        NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:10];
        [dic setObject:@1 forKey:@"expanded"];
        [flags addObject:dic];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //tableView背景色透明
    tableView.backgroundColor = [UIColor clearColor];
    
    //部门数量
    if(tableView == self.carInfotableView)
    {
        return [self.allCarsInfo count];
    }
    else
    {
        return 1;
    }
    
}

//重写委托方法，自定义headerView
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView != self.carInfotableView)
    {
        return nil;
    }
    NSInteger employeeCount = [[self.allCarsInfo objectAtIndex:section] count];
    
    //初始化headerView
    UIView* hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, HEADERVIEWHEIGHT)];
    //headerView背景图片
    UIImageView* headerBackground = [[UIImageView alloc] initWithFrame:hView.frame];
//    [headerBackground setImage:[UIImage imageNamed:@"address_bg_press.png"]];
    [hView addSubview:headerBackground];
    
    //表示展开或合并的箭头imageView
    UIImageView* arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16, 12, 11)];
    if([self isExpanded:section])
    {
        [arrowView setImage:[UIImage imageNamed:@"header_arrow_left.png"]];
    }
    else
    {
        [arrowView setImage:[UIImage imageNamed:@"header_arrow_down.png"]];
    }
    [hView addSubview:arrowView];
    
    //分组名称label
    UILabel* departmentName = [[UILabel alloc] initWithFrame:CGRectMake(23, 0, 237, HEADERVIEWHEIGHT)];
    departmentName.backgroundColor = [UIColor clearColor];
    id carInfoItem = [[self.allCarsInfo objectAtIndex:section] objectAtIndex:0];
    NSString* name = carInfoItem[@"brand"];
    departmentName.text = name;
    departmentName.textColor = [UIColor darkGrayColor];
    departmentName.font=[UIFont systemFontOfSize:12.0];
    [hView addSubview:departmentName];
    
    //headerView上的button
    UIButton* eButton = [[UIButton alloc] initWithFrame:hView.frame];
    [eButton addTarget:self action:@selector(expandButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    eButton.tag = section;
    [hView addSubview: eButton];
    return hView;
}

//返回headerView的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView != self.carInfotableView)
    {
        return 0;
    }
    return HEADERVIEWHEIGHT;
}

//每个分类下的车辆类型数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //非搜索状态
    if(tableView == self.carInfotableView)
    {
        //当前为展开状态
        if([self isExpanded:section])
        {
            return 0;
        }
        else
        {
            return [[self.allCarsInfo objectAtIndex:section] count];
        }
    }
    else
    {
        return [self.allCarsInfo count];
    }
}

//返回cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    NSString* cellIdentifier = @"BrandItemCell";
    
    id item;
    if(tableView == self.carInfotableView)
    {
        item = [[self.allCarsInfo objectAtIndex:section] objectAtIndex:row];
        //从nib文件加载自定义cell
        if(!nib)
        {
            nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        }
    }
    else
    {
        item  = [self.allCarsInfo objectAtIndex:row];
        //从nib文件加载自定义cell
        if(!nib2)
        {
            nib2 = [UINib nibWithNibName:cellIdentifier bundle:nil];
            [tableView registerNib:nib2 forCellReuseIdentifier:cellIdentifier];
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCellBrandItem"];
    if (cell==nil){
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BrandItemCell" owner:nil options:nil] objectAtIndex:0];
    }
    BrandItemCell *aCell = (BrandItemCell *)cell;
  
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    id item;
    if(tableView == self.carInfotableView)
    {
        item = [[self.allCarsInfo objectAtIndex:section] objectAtIndex:row];
    }
    else
    {
        item = [self.allCarsInfo objectAtIndex:row];
    }
    NSLog(@"item=%@",item);
    
    _selected = item;
    self.brand_id = _selected[@"brand_id"];
    self.brand = _selected[@"brand"];
    [self.carInfotableView reloadData];
    return;
}


#pragma mark - 折叠控制
//按钮被点击时触发
-(void)expandButtonClicked:(id)sender
{
    
    UIButton* btn= (UIButton*)sender;
    int section= btn.tag;
    
    // NSLog(@"click %d", section);
    [self collapseOrExpand:section];
    //刷新tableview
    [self.carInfotableView reloadData];
    
}

//对指定的节进行“展开/折叠”操作
-(void)collapseOrExpand:(int)section{
    Boolean expanded = NO;
    //Boolean searched = NO;
    NSMutableDictionary* d=[flags objectAtIndex:section];
    
    //若本节model中的“expanded”属性不为空，则取出来
    if([d objectForKey:@"expanded"]!=nil)
    {
        expanded=[[d objectForKey:@"expanded"]intValue];
    }
    //若原来是折叠的则展开，若原来是展开的则折叠
    [d setObject:[NSNumber numberWithBool:!expanded] forKey:@"expanded"];
    
}

//判断现在是展开状态
-(Boolean)isExpanded:(int)section
{
    Boolean expanded = NO;
    NSMutableDictionary* dic=[flags objectAtIndex:section];
    
    //若本节model中的“expanded”属性不为空，则取出来
    if([dic objectForKey:@"expanded"]!=nil)
    {
        expanded=[[dic objectForKey:@"expanded"]intValue];
    }
    return expanded;
}


@end
