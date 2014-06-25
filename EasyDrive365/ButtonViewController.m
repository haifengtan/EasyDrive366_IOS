//
//  ButtonViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 4/26/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ButtonViewController.h"

@interface ButtonViewController ()

@end

@implementation ButtonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.buttonType =0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.button.text = self.buttonText;
    if (self.buttonType==1){
        self.button.textColor = [UIColor whiteColor];
        self.button.textShadowColor = [UIColor darkGrayColor];
        self.button.tintColor = [UIColor colorWithRed:(CGFloat)120/255 green:0 blue:0 alpha:1];
        self.button.highlightedTintColor = [UIColor colorWithRed:(CGFloat)190/255 green:0 blue:0 alpha:1];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setButton:nil];
    [super viewDidUnload];
}
- (IBAction)buttonPressed:(id)sender {
    if (self.delegate){
        [self.delegate buttonPressed:self.button];
    }
}
@end
