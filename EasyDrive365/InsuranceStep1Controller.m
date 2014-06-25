//
//  InsuranceStep1Controller.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/26/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "InsuranceStep1Controller.h"
#import "AppSettings.h"
#import "InsuranceStep2Controller.h"


#import "InsuranceStep7Controller.h"

@interface InsuranceStep1Controller (){
    
}

@end

@implementation InsuranceStep1Controller

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
    if (self.web_url){
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.web_url]]];
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonSystemItemAction target:self action:@selector(nextStep)];
    }else{
        [self load_data];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)load_data{
    NSString *url;
    if (self.taskid>0)
        url =[NSString stringWithFormat:@"ins/carins_intro?userid=%d&taskid=%d",[AppSettings sharedSettings].userid,self.taskid];
    else
        url =[NSString stringWithFormat:@"ins/carins_intro?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonSystemItemAction target:self action:@selector(nextStep)];
            NSString *content_url = json[@"result"][@"web_url"];// @"http://m.yijia366.com/html/20140123.htm";
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:content_url]]];
        }else{
            self.navigationItem.rightBarButtonItem =nil;
        }
    }];
}

-(void)nextStep{
    InsuranceStep2Controller *vc =[[InsuranceStep2Controller alloc] initWithStyle:UITableViewStyleGrouped];
    vc.goods_id = self.goods_id;
    //InsuranceStep7Controller *vc =[[InsuranceStep7Controller alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
