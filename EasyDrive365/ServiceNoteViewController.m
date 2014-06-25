//
//  ServiceNoteViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 5/9/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ServiceNoteViewController.h"

@interface ServiceNoteViewController ()

@end

@implementation ServiceNoteViewController

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
    self.btnPhone.text=@"";
    self.btnPhone.textColor=[UIColor whiteColor];
    self.btnPhone.textShadowColor = [UIColor darkGrayColor];
    
	self.btnPhone.tintColor = [UIColor colorWithRed:0   green:80.0/255.0 blue:0 alpha:1];
	self.btnPhone.highlightedTintColor = [UIColor colorWithRed:(CGFloat)190/255 green:0 blue:0 alpha:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLblTitle:nil];
    [self setBtnPhone:nil];
    [self setTxtDescription:nil];
    [super viewDidUnload];
}
-(void)setup{
    _helper.url = [[AppSettings sharedSettings] url_for_get_note:self.code];
}
-(void)processData:(id)json{
    NSLog(@"%@",json);
    _company = [json[@"result"] objectForKey:@"company"];
    _phone =[json[@"result"] objectForKey:@"phone"];
    
    id result =json[@"result"][@"data"][0];
    
    NSLog(@"%@",result[@"title"]);
    NSLog(@"%@",result[@"description"]);
    
    self.lblTitle.text=result[@"title"];
    
    self.txtDescription.text =result[@"description"];
    
    self.btnPhone.text=[NSString stringWithFormat:@"拨号：%@",_phone];
    
}

- (IBAction)phoneCall:(id)sender {
    if(_phone){
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[NSString stringWithFormat:@"拨号：%@",_phone ],nil];
        [sheet showInView:self.view];
        
    }
    
    
}
@end
