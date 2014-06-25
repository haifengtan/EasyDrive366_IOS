//
//  TaskDispatch.m
//  EasyDrive366
//
//  Created by Steven Fu on 2/19/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "TaskDispatch.h"
#import "AppSettings.h"
#import "Browser2Controller.h"
#import "ExecuteTaskController.h"
#import "InformationViewController.h"
#import "HelpCallViewController.h"
#import "InsuranceMainController.h"
#import "MaintanViewController.h"
#import "DriverLicenseViewController.h"
#import "CarRegistrationViewController.h"
#import "TaxForCarShipViewController.h"
#import "CIViewController.h"
#import "BusinessInsViewController.h"
#import "AddCardStep1ControllerViewController.h"
#import "CarHelpViewController.h"
#import "InsuranceStep1Controller.h"
#import "Browser2Controller.h"

#import "ProviderListController.h"
#import "GoodsListController.h"
#import "ArticleListController.h"
#import "SettingsViewController.h"
#import "SetupUserController.h"
#import "BoundListController.h"

#import "NeedPayController.h"
#import "InsuranceDetailController.h"
#import "TaskListController.h"
#import "FriendListController.h"
#import "FeedbackController2.h"
#import "NewActivateViewController.h"
#import "MyFavorController.h"
#import "MyHistroyController.h"

#import "ResetPasswordViewController.h"
#import "EditTableViewController.h"
#import "SignupStep1ViewController.h"


@interface TaskDispatch(){
    id _task;
    NSString * _pageId;
    NSString * _task_id;
    UINavigationController *_controller;
    NSString *_action_url;
}
@end

@implementation TaskDispatch
-(id)initWithController:(UINavigationController *)controller task:(id)task{
    self = [[TaskDispatch alloc] init];
    if (self){
        _task = task;
        _controller = controller;
        _action_url = _task[@"action_url"];
        _pageId = _task[@"page_id"];
        _task_id = _task[@"id"];
    }
    return self;
    
}
-(void)pushToController{
    if (_action_url && ![_action_url isEqualToString:@""]){
        Browser2Controller *vc = [[Browser2Controller alloc] initWithNibName:@"Browser2Controller" bundle:nil];
        vc.url = _action_url;
        [_controller pushViewController:vc animated:YES];
    }else if (_pageId && ![_pageId isEqualToString:@""]){
        [self pushToControllerByPageId:_pageId];
    }else{
        ExecuteTaskController *vc = [[ExecuteTaskController alloc] initWithNibName:@"ExecuteTaskController" bundle:nil];
        vc.task_id = [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
    }
}
-(void)pushToControllerByPageId:(NSString *)key{

    if ([key isEqualToString:@"01"]){
        InformationViewController *vc = [[InformationViewController alloc] initWithNibName:@"InformationViewController" bundle:nil];
        vc.taskid =[_task_id intValue];
        [_controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"02"]){
        HelpCallViewController *vc = [[HelpCallViewController alloc] initWithNibName:@"HelpCallViewController" bundle:nil];
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"03"]){

        //should be nothing;
        InsuranceMainController *vc = [[InsuranceMainController alloc] initWithStyle:UITableViewStylePlain];
        
        [_controller pushViewController:vc animated:YES];
    }
    
    if ([key isEqualToString:@"04"]){
        
        MaintanViewController *vc = [[MaintanViewController alloc] initWithNibName:@"MaintanViewController" bundle:nil];
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"05"]){
        DriverLicenseViewController *vc =[[DriverLicenseViewController alloc] initWithNibName:@"DriverLicenseViewController" bundle:nil];
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"06"]){
        CarRegistrationViewController *vc =[[CarRegistrationViewController alloc] initWithNibName:@"CarRegistrationViewController" bundle:nil];
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"07"]){
        TaxForCarShipViewController *vc = [[TaxForCarShipViewController alloc] initWithNibName:@"TaxForCarShipViewController" bundle:nil];
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
        
    }
    if ([key isEqualToString:@"08"]){

        CIViewController *vc = [[CIViewController alloc] initWithNibName:@"CIViewController" bundle:nil];
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
        
    }
    
    if ([key isEqualToString:@"09"]){
        BusinessInsViewController *vc = [[BusinessInsViewController alloc] initWithNibName:@"BusinessInsViewController" bundle:nil];
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
        
    }
    if ([key isEqualToString:@"10"]){
        AddCardStep1ControllerViewController *vc = [[AddCardStep1ControllerViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
        
    }
    if ([key isEqualToString:@"12"]){
        CarHelpViewController *vc = [[CarHelpViewController alloc] initWithNibName:@"CarHelpViewController" bundle:nil];
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
        
    }
    
    if ([key isEqualToString:@"11"]){
        InsuranceStep1Controller *vc =[[InsuranceStep1Controller alloc] initWithNibName:@"InsuranceStep1Controller" bundle:nil];
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
    }
    
    if ([key isEqualToString:@"600"]){
        InsuranceMainController *vc = [[InsuranceMainController alloc] initWithStyle:UITableViewStylePlain];
        [_controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"601"]){
        InsuranceStep1Controller *vc =[[InsuranceStep1Controller alloc] initWithNibName:@"InsuranceStep1Controller" bundle:nil];
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"700"]){
        GoodsListController *vc = [[GoodsListController alloc] initWithStyle:UITableViewStylePlain];
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
    }
    //701
    //702
    
    if ([key isEqualToString:@"720"]){
        ProviderListController *vc =[[ProviderListController alloc] initWithStyle:UITableViewStylePlain];
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
    }
    //721
    //722
    
    if ([key isEqualToString:@"740"]){
        ArticleListController *vc=[[ArticleListController alloc] initWithStyle:UITableViewStylePlain];
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
    }
    
    if ([key isEqualToString:@"800"]){
        SettingsViewController *vc = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [_controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"801"]){
        SetupUserController *vc = [[SetupUserController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
    }

    if ([key isEqualToString:@"805"]){
        BoundListController *vc = [[BoundListController alloc] initWithStyle:UITableViewStylePlain];
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
    }

    if ([key isEqualToString:@"810"]){
        NeedPayController *vc = [[NeedPayController alloc] initWithStyle:UITableViewStylePlain];
        vc.taskid= [_task_id intValue];
        vc.status = @"notpay";
        [_controller pushViewController:vc animated:YES];
    }

    if ([key isEqualToString:@"815"]){
        InsuranceDetailController *vc = [[InsuranceDetailController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"820"]){
        TaskListController *vc = [[TaskListController alloc] initWithStyle:UITableViewStylePlain];
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"821"]){
        
        //?
    }
    if ([key isEqualToString:@"825"]){
        FriendListController *vc =[[FriendListController alloc] initWithStyle:UITableViewStylePlain];
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"830"]){
        FeedbackController2 *vc = [[FeedbackController2 alloc] initWithStyle:UITableViewStyleGrouped];
        vc.title = @"意见反馈";
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"835"]){
        NeedPayController *vc = [[NeedPayController alloc] initWithStyle:UITableViewStylePlain];
        vc.status = @"finished";
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"840"]){
        NewActivateViewController *vc =[[NewActivateViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"845"]){
        MyFavorController *vc = [[MyFavorController alloc] initWithStyle:UITableViewStylePlain];
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
    }
    
    if ([key isEqualToString:@"850"]){
        MyHistroyController *vc = [[MyHistroyController alloc] initWithStyle:UITableViewStylePlain];
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
    }
    
    
    if ([key isEqualToString:@"855"]){
        NSString *url =[NSString stringWithFormat:@"%@&taskid=%@", [[AppSettings sharedSettings] url_get_car_registration],_task_id];
        [[HttpClient sharedHttp] get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                id result=[json objectForKey:@"result"][@"data"];
                
                
                id carDatasource = [[EditCarReigsterationDataSource alloc] initWithData:result];
                EditTableViewController *vc = [[EditTableViewController alloc] initWithDelegate:carDatasource];
                [_controller pushViewController:vc animated:YES];
            }
            
        }];
    }
    if ([key isEqualToString:@"860"]){
        NSString *url =[NSString stringWithFormat:@"%@&taskid=%@", [[AppSettings sharedSettings] url_get_driver_license],_task_id];
        [[HttpClient sharedHttp] get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                id result=[json objectForKey:@"result"][@"data"];
                
                
                id driverDatasource = [[EditDriverLicenseDataSource alloc] initWithData:result];
                EditTableViewController *vc = [[EditTableViewController alloc] initWithDelegate:driverDatasource];
                [_controller pushViewController:vc animated:YES];
            }
            
        }];
    }
    if ([key isEqualToString:@"865"]){
        NSString *url =[NSString stringWithFormat:@"%@&taskid=%@", [[AppSettings sharedSettings] url_for_get_maintain_record],_task_id];
        [[HttpClient sharedHttp] get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                id temp=[json objectForKey:@"result"][@"data"];
                
                NSLog(@"%@",temp);
                NSEnumerator *enumerator =[temp keyEnumerator];
                id key;
                id result = [[NSMutableDictionary alloc] init];
                while ((key=[enumerator nextObject])) {
                    id value = [temp objectForKey:key];
                    if ([value isKindOfClass:[NSNull class]]){
                        [result setObject:@"" forKey:key];
                        
                    }else{
                        [result setObject:value?value:@"" forKey:key];
                    }
                }
                id maintainDatasource = [[EditMaintainDataSource alloc] initWithData:result];
                EditTableViewController *vc = [[EditTableViewController alloc] initWithDelegate:maintainDatasource];
                [_controller pushViewController:vc animated:YES];
            }
            
        }];
    }
    if ([key isEqualToString:@"870"]){
        ResetPasswordViewController *vc = [[ResetPasswordViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [_controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"875"]){
        //bind and unbind cellphone
    }
    if ([key isEqualToString:@"880"]){
       //find password back
    }
    if ([key isEqualToString:@"885"]){
        SignupStep1ViewController *vc = [[SignupStep1ViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.taskid= [_task_id intValue];
        [_controller pushViewController:vc animated:YES];
    }
    
    
}
@end
