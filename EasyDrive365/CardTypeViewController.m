//
//  CardTypeViewController.m
//  EasyDrive366
//
//  Created by admin on 14-8-19.
//  Copyright (c) 2014年 Fu Steven. All rights reserved.
//

#import "CardTypeViewController.h"

@interface CardTypeViewController (){
     NSArray *fontAry;
}

@end

@implementation CardTypeViewController

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
    fontAry = [NSArray arrayWithObjects:@"身份证",@"护照",nil];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(selectDate:)];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectDate:(id)sender{
    
     NSInteger row=[_cardTypePicker selectedRowInComponent:0];
     NSString *date_value=[fontAry objectAtIndex:row];
    
    if (self.delegate){
        [self.delegate setValueByKey:date_value key:self.keyname];
    }

    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark pickerview function

/* return cor of pickerview*/
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
/*return row number*/
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [fontAry count];
}

/*return component row str*/
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [fontAry objectAtIndex:row];
}

/*choose com is component,row's function*/
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

}

@end
