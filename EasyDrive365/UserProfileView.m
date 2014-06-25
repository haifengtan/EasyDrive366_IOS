//
//  UserProfileView.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/19/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "UserProfileView.h"
#import "AppSettings.h"
#import "UIImageView+AFNetworking.h"
#import "BoundListController.h"
#import "FriendListController.h"
#import "NeedPayController.h"
#import "TaskListController.h"
#import "SetupUserController.h"
#import "InsuranceDetailController.h"
#import "Browser2Controller.h"
@implementation UserProfileView

-(id)initWithController:(UINavigationController *)parent  taskid:(int)taskid{
    self =[[[NSBundle mainBundle] loadNibNamed:@"UserProfileView" owner:nil options:nil] objectAtIndex:0];
    if (self){
        self.backgroundColor = [UIColor clearColor];
        _parent = parent;
        self.lblBound.text=@"";
        self.lblExp.text=@"";
        self.lblSignature.text=@"";
        self.lblUsername.text=@"";
        self.imageAvater.image=nil;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openBound)];
        [self.lblBound addGestureRecognizer:tap];
        
        UITapGestureRecognizer *tapOnView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setupUser)];
        [self addGestureRecognizer:tapOnView];
        [self load_data:taskid];
    }
    return self;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setupUser{
    SetupUserController *vc = [[SetupUserController alloc] initWithStyle:UITableViewStyleGrouped];
    //[_parent presentViewController:vc animated:YES completion:Nil];
    [_parent pushViewController:vc animated:YES];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (IBAction)needPayPressed:(id)sender {
    NeedPayController *vc = [[NeedPayController alloc] initWithStyle:UITableViewStylePlain];
    vc.status = @"notpay";
    [_parent pushViewController:vc animated:YES];
}
- (IBAction)myInsurancePressed:(id)sender {
    /*
    InsuranceDetailController *vc = [[InsuranceDetailController alloc] initWithStyle:UITableViewStyleGrouped];
    [_parent pushViewController:vc animated:YES];
    */
    /*
    NeedPayController *vc = [[NeedPayController alloc] initWithStyle:UITableViewStylePlain];
    vc.status = @"finished&type=ins";
    [_parent pushViewController:vc animated:YES];
     */
    Browser2Controller *vc = [[Browser2Controller alloc] initWithNibName:@"Browser2Controller" bundle:nil];
    vc.url = [NSString stringWithFormat:@"http://m.4006678888.com:21000/index.php/prize/summary?userid=%d",[AppSettings sharedSettings].userid];
    vc.browser_title = @"我的积分";
    [_parent pushViewController:vc animated:YES];
    
}
- (IBAction)myTaskPressed:(id)sender {
    TaskListController *vc = [[TaskListController alloc] initWithStyle:UITableViewStylePlain];
    [_parent pushViewController:vc animated:YES];
}
- (IBAction)myFriendPressed:(id)sender {
    FriendListController *vc =[[FriendListController alloc] initWithStyle:UITableViewStylePlain];
    [_parent pushViewController:vc animated:YES];
}

-(void)load_data:(int)taskid{
    NSString *url;
    if (taskid>0)
        url = [NSString stringWithFormat:@"bound/get_user_set?userid=%d&taskid=%d",[AppSettings sharedSettings].userid,taskid];
    else
        url = [NSString stringWithFormat:@"bound/get_user_set?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            self.lblBound.text=[NSString stringWithFormat:@"积分：%@",json[@"result"][@"bound"]];
            self.lblExp.text=[NSString stringWithFormat:@"%@",json[@"result"][@"exp_label"]];
            self.lblSignature.text=[AppSettings getStringDefault:json[@"result"][@"signature"] default:@"啥也没有说"];
            self.lblUsername.text=[AppSettings getStringDefault:json[@"result"][@"nickname"] default:@"(未设置)"];
            [self.imageAvater setImageWithURLWithoutCache:[NSURL URLWithString:json[@"result"][@"photourl"]] placeholderImage:[UIImage imageNamed:@"m.png"]];
            CGFloat exp = [json[@"result"][@"exp"] floatValue];
            CGFloat nextlevel = [json[@"result"][@"exp_nextlevel"] floatValue];
            [self.pvExp setProgress:(exp /nextlevel) animated:YES];
            

        }
    }];
}
-(void)openBound{
    BoundListController *vc = [[BoundListController alloc] initWithStyle:UITableViewStylePlain];
    [_parent pushViewController:vc animated:YES];
}

@end
