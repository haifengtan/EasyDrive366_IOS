//
//  ShowDetailViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 8/27/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ShowDetailViewController.h"
#import "NavigationViewController.h"

@interface ShowDetailViewController (){
    id _data;

}

@end

@implementation ShowDetailViewController

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
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
#endif
    [super viewDidLoad];
    if (_data){
        self.lblPhone.text = _data[@"phone"];
        self.lblAddress.text=_data[@"address"];
        self.lblDescription.text=_data[@"description"];
        self.lblName.text = _data[@"name"];
        self.title = self.lblName.text;
    }else{
        self.lblAddress.text=@"";
        self.lblDescription.text=@"";
        self.lblName.text = @"";
        self.lblPhone.text=@"";
    }

    self.btnNav.text = @"导航到这里";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLblName:nil];
    [self setLblAddress:nil];
    [self setLblPhone:nil];
    [self setLblDescription:nil];



    [self setBtnNav:nil];
    [super viewDidUnload];
}
-(void)loadData:(id)data{
    self.lblPhone.text = data[@"phone"];
    self.lblAddress.text=data[@"address"];
    self.lblDescription.text=data[@"description"];
    self.lblName.text = data[@"name"];
    self.title = self.lblName.text;
    _data = data;
}
- (IBAction)buttonNavPressed:(id)sender {
    NavigationViewController *controller = [[NavigationViewController alloc] initWithNibName:@"NavigationViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    controller.target = self.target;
    controller.title = self.lblName.text;
}

@end
