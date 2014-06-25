//
//  ExecuteTaskController.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/20/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ExecuteTaskController.h"
#import "AppSettings.h"
#import "UIImageView+AFNetworking.h"


@interface ExecuteTaskController (){
    BOOL _hasGet;
    BOOL _is_finished;
}

@end

@implementation ExecuteTaskController

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
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
#endif

    self.lblTitle.text=@"";
    self.lblContent.text=@"";
    self.lblRemark.text=@"";
    self.button.text=@"";
    _hasGet = NO;
    _is_finished = NO;
    [self load_data];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonPressed:(id)sender {
    if (_hasGet && !_is_finished){
        NSString *url = [NSString stringWithFormat:@"bound/exec_task?userid=%d&taskid=%d",[AppSettings sharedSettings].userid,self.task_id];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                _hasGet = NO;
                [self load_data];
            }
        }];
    }
}
-(void)load_data{
    NSString *url = [NSString stringWithFormat:@"bound/get_task?userid=%d&taskid=%d",[AppSettings sharedSettings].userid,self.task_id];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            NSLog(@"%@",json);
            self.lblRemark.text = json[@"result"][@"remark"];
            self.lblTitle.text = json[@"result"][@"title"];
            self.lblContent.text = json[@"result"][@"content"];
            [self.image setImageWithURL:[NSURL URLWithString:json[@"result"][@"pic_url"]]];
            _hasGet = YES;
            _is_finished = [json[@"result"][@"is_finished"] boolValue];
            if (_is_finished){
                self.button.text = @"更多惊喜去商城看看";
            }else{
                self.button.text = json[@"result"][@"title"];
            }
        }
    }];
}

@end
