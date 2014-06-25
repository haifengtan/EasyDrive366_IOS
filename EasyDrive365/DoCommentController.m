//
//  DoCommentController.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/18/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "DoCommentController.h"
#import "AMRatingControl.h"
#import "AppSettings.h"
#import <QuartzCore/QuartzCore.h>
@interface DoCommentController ()<UITextViewDelegate>{
    AMRatingControl *_ratingView;
}

@end

@implementation DoCommentController

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
    self.btnOK.text = @"保存";
    [self textViewDidChange:self.txtComment];
    self.txtComment.layer.borderWidth=2.0f;
    self.txtComment.layer.borderColor=[[UIColor grayColor] CGColor];
    self.txtComment.delegate = self;
    _ratingView = [[AMRatingControl alloc] initWithLocation:CGPointMake(40, 20) andMaxRating:5 withRadius:50];
    [_ratingView setRating:1];
    [self.view addSubview:_ratingView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(buttonPressed:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textViewDidChange:(UITextView *)textView{
    int count = 200- textView.text.length;
    self.lblLeft.text= [NSString stringWithFormat:@"还可以输入%d个字",count];
    if (textView.text.length>=200){
        [textView resignFirstResponder];
        
        
    }
}
- (IBAction)buttonPressed:(id)sender {
    NSString *url = [NSString stringWithFormat:@"comment/edit_comment?userid=%d&id=%@&type=%@&comment=%@&star=%d",
                     [AppSettings sharedSettings].userid,
                     self.item_id,
                     self.item_type,
                     self.txtComment.text,
                     _ratingView.rating
                     ];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:ADD_COMMENT_SUCCESS object:Nil];
        }
    }];
}
@end
