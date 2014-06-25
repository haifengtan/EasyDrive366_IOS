//
//  LoginViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 1/29/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "LoginViewController.h"
#import "AppSettings.h"
#import "AFNetworking.h"
#import "AFHTTPClient.h"
#import "HttpClient.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtUsername:nil];
    [self setTxtPassword:nil];
    [super viewDidUnload];
}
- (IBAction)login {
    //[self doLogin];
    NSString *path  =[NSString stringWithFormat:@"api/login?username=%@&password=%@",self.txtUsername.text,self.txtPassword.text];
    [[HttpClient sharedHttp] get:path block:^(id json) {
        if (json){
            NSString *status =[json objectForKey:@"status"];
            if (status && [status isEqualToString:@"success"]){
                //success login
                //{"status":"success","result":[{"id":"2","username":"2","password":"1"}]}
                NSLog(@"%@",json);
                [AppSettings sharedSettings].isLogin = TRUE;
                [AppSettings sharedSettings].firstName = self.txtUsername.text;
                [AppSettings sharedSettings].lastName = self.txtPassword.text;
                //NSNumber *userid=[[json objectForKey:@"result"][0] objectForKey:@"id"];
                NSNumber *userid=[[json objectForKey:@"result"] objectForKey:@"id"];
                [AppSettings sharedSettings].userid =  [userid intValue];
                [[AppSettings sharedSettings] save];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else{
                self.txtUsername.text = [json objectForKey:@"message"];
            }
        }
    }];
    
}
-(void)doLogin{
    NSURL *url = [NSURL URLWithString:SERVERURL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSString *path  =[NSString stringWithFormat:@"api/login?username=%@&password=%@",self.txtUsername.text,self.txtPassword.text];
    NSMutableURLRequest *request =[httpClient requestWithMethod:@"POST" path:path parameters:nil];
    AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //get json result;
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJapaneseEUCStringEncoding error:&error];
        if (json){
            NSString *status =[json objectForKey:@"status"];
            if (status && [status isEqualToString:@"success"]){
                //success login
                //{"status":"success","result":[{"id":"2","username":"2","password":"1"}]}
                [AppSettings sharedSettings].isLogin = TRUE;
                [AppSettings sharedSettings].firstName = self.txtUsername.text;
                [AppSettings sharedSettings].lastName = self.txtPassword.text;
                [[AppSettings sharedSettings] save];
                [self.navigationController popToRootViewControllerAnimated:YES];

            }else{
                self.txtUsername.text = [json objectForKey:@"message"];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure.
    }];
    NSOperationQueue *queue =[[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}
@end
