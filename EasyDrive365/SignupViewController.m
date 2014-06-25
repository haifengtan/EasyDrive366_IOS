//
//  SignupViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 1/29/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "SignupViewController.h"
#import "AFNetworking.h"
#import "AFHTTPClient.h"
#import "AppSettings.h"
#import "HttpClient.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

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
	self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(signup)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)signup{
    NSString *path =[NSString stringWithFormat:@"api/signup"];
    NSDictionary *parameter =@{@"username" :self.txtUsername.text,@"password":self.txtPassword.text};
    [[HttpClient sharedHttp] post:path parameters:parameter block:^(id json) {
        if (json){
            NSString *status =[json objectForKey:@"status"];
            if (status && [status isEqualToString:@"success"]){
                [AppSettings sharedSettings].isLogin = TRUE;
                [AppSettings sharedSettings].firstName = self.txtUsername.text;
                [AppSettings sharedSettings].lastName = self.txtPassword.text;
                [[AppSettings sharedSettings] save];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                self.lblInfor.text = [json objectForKey:@"message"];
            }
        }
    }];
}

- (void)viewDidUnload {
    [self setTxtUsername:nil];
    [self setTxtPassword:nil];
    [self setLblInfor:nil];
    [super viewDidUnload];
}
@end
