//
//  GuideController.m
//  EasyDrive366
//
//  Created by Steven Fu on 4/10/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "GuideController.h"
#import "AppDelegate.h"

@interface GuideController (){
    id _list;

}

@end

@implementation GuideController

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

    _list=@[@"01",@"02",@"03",@"04"];
    [_pager setCurrentPage:0];
    [self.imagePicture setImage:[UIImage imageNamed:[_list objectAtIndex:[_pager currentPage]]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    NSLog(@"%@",sender);
    if ([_pager currentPage]==3){
        [self dismissViewControllerAnimated:YES completion:^{
            [((AppDelegate *)[[UIApplication sharedApplication] delegate]) createControllers];
        }];
    }
}
- (IBAction)swipeRight:(UISwipeGestureRecognizer *)sender {
    NSLog(@"%@",sender);
    [_pager setCurrentPage:[_pager currentPage]-1];
    [self.imagePicture setImage:[UIImage imageNamed:[_list objectAtIndex:[_pager currentPage]]]];
}
- (IBAction)swipeLeft:(UISwipeGestureRecognizer *)sender {
    NSLog(@"%@",sender);
    [_pager setCurrentPage:[_pager currentPage]+1];
    [self.imagePicture setImage:[UIImage imageNamed:[_list objectAtIndex:[_pager currentPage]]]];

}
- (IBAction)pageChanged:(id)sender {
    NSLog(@"%@",sender);
}
@end
