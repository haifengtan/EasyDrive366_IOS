//
//  WelcomeViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 3/13/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "WelcomeViewController.h"
#import "LoginTableViewController.h"
#import "SignUpTableViewController.h"
#import "SignupStep1ViewController.h"


@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

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
    self.title = @"登录和注册";
    //[self.navigationItem setBackBarButtonItem:nil];
    //self.navigationItem.hidesBackButton=YES;
    self.loginBtn.text = @"登录";
    self.signupBtn.text =@"注册";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(id)sender {
    LoginTableViewController *vc = [[LoginTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    //SignUpTableViewController *vc =[[SignUpTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)signup:(id)sender {
    
    SignUpTableViewController *vc =[[SignUpTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    //SignupStep1ViewController *vc = [[SignupStep1ViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
     
}
- (void)viewDidUnload {
    [self setLoginBtn:nil];
    [self setSignupBtn:nil];
    [super viewDidUnload];
}
@end
