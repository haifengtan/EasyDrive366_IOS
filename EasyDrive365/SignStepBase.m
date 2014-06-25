//
//  SignStepBase.m
//  EasyDrive366
//
//  Created by Steven Fu on 5/10/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "SignStepBase.h"

@interface SignStepBase (){
    UIView *_footer;
}

@end

@implementation SignStepBase

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0){
        if (!_footer){
            _footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
            _footer.backgroundColor = [UIColor clearColor];
            UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 310, 30)];
            header.text = self.header_text;
            [_footer addSubview:header];
            UITextView *remark = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, 310, 150)];
            remark.backgroundColor =[UIColor clearColor];
            remark.text=self.remark_text;
            [_footer addSubview:remark];
            
        }
        return  _footer;
    }
    return  nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0)
        return 400.0f;
    else
        return 22.0f;
}

@end
