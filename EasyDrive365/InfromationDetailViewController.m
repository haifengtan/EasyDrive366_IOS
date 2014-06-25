//
//  InfromationDetailViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 6/7/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "InfromationDetailViewController.h"
#import "AppSettings.h"

@interface InfromationDetailViewController (){
    NSString *_information_id;
}

@end

@implementation InfromationDetailViewController

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
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
#endif
    // Do any additional setup after loading the view from its nib.
    self.lblTitle.text=@"";
    self.txtContent.text = @"";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonSystemItemTrash target:self action:@selector(deleteInfor)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLblTitle:nil];
    
    [self setTxtContent:nil];
    [super viewDidUnload];
}
-(void)deleteInfor{
    NSString *url = [NSString stringWithFormat:@"api/del_news?userid=%d&newsid=%@",[AppSettings sharedSettings].userid,_information_id];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        NSLog(@"%@",json);
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:DELETE_INFORMATION object:nil];
    }];
}
-(void)loadInformation:(NSString *)information_id{
    _information_id = information_id;
    NSString *url =[NSString stringWithFormat:@"api/get_news_by_id?userid=%d&newsid=%@",[AppSettings sharedSettings].userid,_information_id];
    NSLog(@"%@",url);
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        NSLog(@"%@",json);
        id data = json[@"result"][@"data"][0];
        self.lblTitle.text = data[@"fmt_createDate"];
        self.txtContent.text = data[@"description"];
    }];
}
@end
