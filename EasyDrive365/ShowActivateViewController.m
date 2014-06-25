//
//  ShowActivateViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 8/6/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ShowActivateViewController.h"
#import "AppSettings.h"

@interface ShowActivateViewController ()

@end

@implementation ShowActivateViewController

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
    self.title = @"激活信息";
    self.lblCode.text = @"";
    self.lblNo.text = @"";
    self.lblTime.text = @"";
    self.lblTo.text = @"";
    /*
    NSString *url =[NSString stringWithFormat:@"api/get_activate_code?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            self.lblCode.text = json[@"result"][@"number"];
            self.lblNo.text = json[@"result"][@"code"];
            self.lblTime.text = json[@"result"][@"activate_date"];
            self.lblTo.text = json[@"result"][@"valid_date"];
        }
    }];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLblNo:nil];
    [self setLblCode:nil];
    [self setLblTime:nil];
    [self setLblTo:nil];
    [super viewDidUnload];
}
@end
