//
//  SingleCardViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 10/22/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "SingleCardViewController.h"
#import "Browser2Controller.h"

@interface SingleCardViewController (){
    id _list;
    id _sections;
}

@end

@implementation SingleCardViewController

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
    self.title = self.data[@"title"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看条款" style:UIBarButtonSystemItemAction target:self action:@selector(viewUrl)];
    
    id sections1= @[@{@"title":@"保单号",@"detail":self.data[@"po"]},
                    @{@"title":@"保险期限",@"detail":self.data[@"valid"]}];
    id sections2= @[@{@"title":@"姓名",@"detail":self.data[@"insured_name"]},
                    @{@"title":@"身份证",@"detail":self.data[@"insured_idcard"]},
                    @{@"title":@"手机号",@"detail":self.data[@"insured_phone"]},
                    @{@"title":@"保险地址",@"detail":self.data[@"insured_address"]}];
    id sections3;
    BOOL is_agreed_bf = [self.data[@"is_agreed_bf"] boolValue];
    if (!is_agreed_bf){
        sections3=@[@{@"title":@"约定受益人",@"detail":self.data[@"is_agreed_bf_label"]}];
    }else{
        sections3=@[@{@"title":@"约定受益人",@"detail":@""},
                    @{@"title":@"姓名",@"detail":self.data[@"bf_name"]},
                    @{@"title":@"身份证",@"detail":self.data[@"bf_id"]}];
    }
    id sections4 =[[NSMutableArray alloc] initWithCapacity:[self.data[@"list"] count]];
    for (id item in self.data[@"list"]) {
        [sections4 addObject:@{@"title":item[@"InsuName"],@"detail":[NSString stringWithFormat:@"%@",item[@"Amount"]]}];
    }
    _list =@[sections1,sections2,sections3,sections4];
    _sections = @[@"基本信息",@"被保险人",@"受益人",@"保障项目"];
}
-(void)viewUrl{
    //self.data[@"url"];
    Browser2Controller *vc = [[Browser2Controller alloc] initWithNibName:@"Browser2Controller" bundle:nil];
    vc.title = self.title;
    NSString *url = self.data[@"url"];
    if (![[[url substringToIndex:5] lowercaseString] isEqualToString:@"http:"]){
        vc.url = [NSString stringWithFormat:@"http://%@",url];
    }else{
        vc.url = url;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_list objectAtIndex:section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"InsCardTableCellView";
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    id item =[[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = item[@"title"];
    cell.detailTextLabel.text = item[@"detail"];
    [cell.detailTextLabel sizeToFit];
    return cell;
}

@end
