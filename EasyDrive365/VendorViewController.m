//
//  VendorViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 5/9/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "VendorViewController.h"

@interface VendorViewController (){
    NSString *_shop_name;
    NSString *_address;
    NSString *_shop_phone;
    NSString *_description;
}

@end

@implementation VendorViewController

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
    self.phoneButton.text=@"";
    self.phoneButton.textColor=[UIColor whiteColor];
    self.phoneButton.textShadowColor = [UIColor darkGrayColor];
    
	self.phoneButton.tintColor = [UIColor colorWithRed:0   green:80.0/255.0 blue:0 alpha:1];
	self.phoneButton.highlightedTintColor = [UIColor colorWithRed:(CGFloat)190/255 green:0 blue:0 alpha:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidUnload{
    [self setLblShopName:nil];
    [self setLblAddress:nil];
    [self setTextDescription:nil];

    [self setPhoneButton:nil];
    [super viewDidUnload];
    
}

-(void)setup{
    _helper.url = [[AppSettings sharedSettings] url_for_get_vender:self.code];
}
-(void)processData:(id)json{
    _company = [json[@"result"] objectForKey:@"company"];
    _phone =[json[@"result"] objectForKey:@"phone"];
    
    id result =[json objectForKey:@"result"][@"data"];
    _shop_name =[result objectForKey:@"shop_name"];
    _address =[result objectForKey:@"address"];
    _shop_phone =[result objectForKey:@"phone"];
    _description =[result objectForKey:@"description"];
    
    
    [self updateData];
}
-(void)updateData{
    self.lblShopName.text = _shop_name;
    self.lblAddress.text =_address;
    //self.lblPhone.text = _phone;
    self.textDescription.text =_description;
    self.phoneButton.text=[NSString stringWithFormat:@"拨号：%@",_shop_phone];
}
- (IBAction)phoneCall:(id)sender {
    if(_shop_phone){
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[NSString stringWithFormat:@"拨号：%@",_shop_phone ],nil];
        [sheet showInView:self.view];
        
    }
    
    
}

@end
