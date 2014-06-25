//
//  JobDetailController.m
//  EasyDrive366
//
//  Created by Steven Fu on 3/21/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "JobDetailController.h"
#import "AppSettings.h"

@interface JobDetailController ()

@end

@implementation JobDetailController

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
    self.title = @"职业明细";
    [self init_data];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)init_data{
    NSString *url = [NSString stringWithFormat:@"order/get_career?userid=%d&id=%d",[AppSettings sharedSettings].userid,self.job_id];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            id result = json[@"result"];
            self.lblName.text = result[@"trade_name"];
            self.lblTitle.text = result[@"name"];
            self.lblLevel.text = result[@"level"];
            self.txtContent.text = result[@"content"];
        }
    }];
}
@end
