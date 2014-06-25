//
//  AddCommentViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 6/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "AddCommentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppSettings.h"

@interface AddCommentViewController ()<UITextViewDelegate>

@end

@implementation AddCommentViewController

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
    self.txtContent.delegate = self;
    [self textViewDidChange:self.txtContent];
    self.txtContent.layer.borderWidth = 2.0f;
    self.txtContent.layer.borderColor =[[UIColor grayColor] CGColor];
    self.buttonAdd.text =@"评论";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtContent:nil];
    [self setButtonAdd:nil];
    [self setLblLeft:nil];
    [super viewDidUnload];
}

-(void)textViewDidChange:(UITextView *)textView{
    int count = 200- textView.text.length;
    self.lblLeft.text= [NSString stringWithFormat:@"还可以输入%d个字",count];
    if (textView.text.length>=200){
        [textView resignFirstResponder];
        
        
    }
}
- (IBAction)buttonAddPressed:(id)sender {
    if ([self.txtContent.text length]>0){
        NSString *url = [NSString stringWithFormat:@"article/set_review?user_id=%d&column_id=%@&article_id=%@&content=%@",
                         [AppSettings sharedSettings].userid,
                         _article[@"column_id"],
                         _article[@"id"],
                         self.txtContent.text];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        [self.txtContent becomeFirstResponder];
    }
}
@end
