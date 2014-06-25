//
//  QRCodeShowViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 9/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "QRCodeShowViewController.h"
#import "QRCodeGenerator.h"

@interface QRCodeShowViewController ()

@end

@implementation QRCodeShowViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtBarcode:nil];
    [self setImageView:nil];
    [super viewDidUnload];
}
- (IBAction)buttonPressed:(id)sender {
    [self.txtBarcode resignFirstResponder];
    self.imageView.image =[QRCodeGenerator qrImageForString:self.txtBarcode.text imageSize:self.imageView.bounds.size.width];
}
@end
