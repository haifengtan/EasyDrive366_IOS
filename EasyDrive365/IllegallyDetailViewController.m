//
//  IllegallyDetailViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 5/22/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "IllegallyDetailViewController.h"

@interface IllegallyDetailViewController ()

@end

@implementation IllegallyDetailViewController

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
    self.title = @"详细内容";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLblTitle:nil];
    [self setLblAddress:nil];
    [self setLblContent:nil];
    [super viewDidUnload];
}
@end
