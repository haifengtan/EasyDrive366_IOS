//
//  Menu.m
//  EasyDrive365
//  我的页面中的菜单项
//  Created by Fu Steven on 2/6/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "Menu.h"
#import "MenuItem.h"
#import "InformationViewController.h"
#import "HelpCallViewController.h"
#import "AccidentRescueViewController.h"

#import "DriverLicenseViewController.h"
#import "CarRegistrationViewController.h"
#import "TaxForCarShipViewController.h"
#import "CompulsoryInsuranceViewController.h"
#import "BusinessInsuranceViewController.h"
#import "InsuranceRecordsViewController.h"
#import "MaintainListViewController.h"
#import "Browser2Controller.h"
#import "BusinessInsViewController.h"
#import "MaintanViewController.h"

#import "CIViewController.h"
#import "CarHelpViewController.h"

#import "InsuranceMainController.h"
#import "InsuranceStep1Controller.h"

#import "AddCardStep1ControllerViewController.h"
#import "InsuranceListController.h"
#import "NeedPayController.h"
#import "UserProfileController.h"

@implementation Menu
@synthesize list = _list;
@synthesize insurance_list = _insurance_list;
+(Menu *)sharedMenu
{
    static Menu*_instance;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        
        _instance =[[Menu alloc] init];
    });
    return _instance;
    
}

-(id)init
{
    self =[super init];
    if (self){
        NSString *defaultInfo = @"";
        NSString *defaultPhone=@"";
        _list=[NSArray arrayWithObjects:[
            [MenuItem alloc] initWithName:@"14" title:@"我的订单" description:defaultInfo imagePath:@"dingdan.png" phone:defaultPhone],
               
            [[MenuItem alloc] initWithName:@"01" title:@"最新信息" description:defaultInfo imagePath:@"xinxi.png" phone:defaultPhone],
            //[[MenuItem alloc] initWithName:@"02" title:@"紧急救助" description:defaultInfo imagePath:@"main_menu/n.png" phone:defaultPhone],
            /*[[MenuItem alloc] initWithName:@"03" title:@"事故救援" description:defaultInfo imagePath:@"0003.png" phone:defaultPhone],*/
            [[MenuItem alloc] initWithName:@"04" title:@"保养建议" description:defaultInfo imagePath:@"baoyang.png" phone:defaultPhone],
            //[[MenuItem alloc] initWithName:@"12" title:@"车务服务" description:defaultInfo imagePath:@"main_menu/o.png" phone:defaultPhone],
               
               [[MenuItem alloc] initWithName:@"06" title:@"我的车辆" description:defaultInfo imagePath:@"cheliang.png" phone:defaultPhone],
               [[MenuItem alloc] initWithName:@"05" title:@"驾驶证" description:defaultInfo imagePath:@"jiashizheng.png" phone:defaultPhone],
               [[MenuItem alloc] initWithName:@"03" title:@"我的保险" description:defaultInfo imagePath:@"baoxian.png" phone:defaultPhone],
               [[MenuItem alloc] initWithName:@"15" title:@"我的资料" description:defaultInfo imagePath:@"ziliao.png" phone:defaultPhone],
            //[[MenuItem alloc] initWithName:@"11" title:@"维修记录" description:defaultInfo imagePath:@"0011.png" phone:defaultPhone],
            nil];
        _insurance_list=@[[[MenuItem alloc] initWithName:@"07" title:@"车船税" description:defaultInfo imagePath:@"main_menu/q.png" phone:defaultPhone],
                          [[MenuItem alloc] initWithName:@"08" title:@"交强险" description:defaultInfo imagePath:@"main_menu/s.png" phone:defaultPhone],
                          [[MenuItem alloc] initWithName:@"09" title:@"商业险" description:defaultInfo imagePath:@"main_menu/t.png" phone:defaultPhone],
                         
                          //[[MenuItem alloc] initWithName:@"11" title:@"购买车险" description:defaultInfo imagePath:@"main_menu/r.png" phone:defaultPhone],
                          //[[MenuItem alloc] initWithName:@"10" title:@"购买意外险" description:defaultInfo imagePath:@"main_menu/n.png" phone:defaultPhone],
                          [[MenuItem alloc] initWithName:@"13" title:@"保险订单" description:defaultInfo imagePath:@"p.png" phone:defaultPhone]
                          
                          ];
    }
    return self;
}
-(NSString *)getTitleByKey:(NSString *)key{
    for(MenuItem *item in _list){
        if ([item.name isEqualToString:key]){
            return item.title;
        }
    }
    return AppTitle;
}
-(void)pushToController:(UINavigationController *)controller key:(NSString *)key title:(NSString *)title url:(NSString *)url{
    
    if ([key isEqualToString:@"01"]){
        InformationViewController *vc = [[InformationViewController alloc] initWithNibName:@"InformationViewController" bundle:nil];
        vc.title = title;
        //vc.taskid=1;
        [controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"02"]){
        HelpCallViewController *vc = [[HelpCallViewController alloc] initWithNibName:@"HelpCallViewController" bundle:nil];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"03"]){
        /*
        AccidentRescueViewController *vc = [[AccidentRescueViewController alloc] initWithNibName:@"AccidentRescueViewController" bundle:nil];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
         */
        InsuranceMainController *vc = [[InsuranceMainController alloc] initWithStyle:UITableViewStylePlain];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
    }
    
    if ([key isEqualToString:@"04"]){
        
        MaintanViewController *vc = [[MaintanViewController alloc] initWithNibName:@"MaintanViewController" bundle:nil];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"05"]){
        DriverLicenseViewController *vc =[[DriverLicenseViewController alloc] initWithNibName:@"DriverLicenseViewController" bundle:nil];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"06"]){
        CarRegistrationViewController *vc =[[CarRegistrationViewController alloc] initWithNibName:@"CarRegistrationViewController" bundle:nil];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"07"]){
        TaxForCarShipViewController *vc = [[TaxForCarShipViewController alloc] initWithNibName:@"TaxForCarShipViewController" bundle:nil];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
        
    }
    if ([key isEqualToString:@"08"]){
        //CompulsoryInsuranceViewController *vc = [[CompulsoryInsuranceViewController alloc] initWithNibName:@"CompulsoryInsuranceViewController" bundle:nil];
        CIViewController *vc = [[CIViewController alloc] initWithNibName:@"CIViewController" bundle:nil];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
        
    }
    
    if ([key isEqualToString:@"09"]){
        BusinessInsViewController *vc = [[BusinessInsViewController alloc] initWithNibName:@"BusinessInsViewController" bundle:nil];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
        
    }
    if ([key isEqualToString:@"10"]){
        /*
        InsuranceRecordsViewController *vc = [[InsuranceRecordsViewController alloc] initWithNibName:@"InsuranceRecordsViewController" bundle:nil];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
         */
        AddCardStep1ControllerViewController *vc = [[AddCardStep1ControllerViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
        
    }
    if ([key isEqualToString:@"12"]){
        CarHelpViewController *vc = [[CarHelpViewController alloc] initWithNibName:@"CarHelpViewController" bundle:nil];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
        
    }
    
    if ([key isEqualToString:@"11"]){
//        MaintainListViewController *vc = [[MaintainListViewController alloc] initWithNibName:@"MaintainListViewController" bundle:nil];
     //   CIViewController *vc = [[CIViewController alloc] initWithNibName:@"CIViewController" bundle:nil];
        InsuranceStep1Controller *vc =[[InsuranceStep1Controller alloc] initWithNibName:@"InsuranceStep1Controller" bundle:nil];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
    //    [controller presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
    
        
    }
    
     
    if ([key isEqualToString:@"00"] && url){
        Browser2Controller *vc = [[Browser2Controller alloc] initWithNibName:@"Browser2Controller" bundle:nil];
        vc.title = title;
        vc.url = url;
        [controller pushViewController:vc animated:YES];

    }
    if ([key isEqualToString:@"13"]){
        /*
        InsuranceListController *vc = [[InsuranceListController alloc] initWithStyle:UITableViewStylePlain];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
         */
        NeedPayController *vc = [[NeedPayController alloc] initWithStyle:UITableViewStylePlain];
        vc.status = @"finished&type=ins";
        [controller pushViewController:vc animated:YES];
        
    }
    
    if ([key isEqualToString:@"14"]){
        NeedPayController *vc = [[NeedPayController alloc] initWithStyle:UITableViewStylePlain];
        vc.status = @"finished";
        [controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"15"])
    {
        UserProfileController *vc = [[UserProfileController alloc] initWithStyle:UITableViewStyleGrouped];
        [controller pushViewController:vc animated:YES];
    }
}

@end
