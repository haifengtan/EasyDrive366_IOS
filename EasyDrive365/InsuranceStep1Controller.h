//
//  InsuranceStep1Controller.h
//  EasyDrive366
//  购买保险第一步
//  Created by Steven Fu on 1/26/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsuranceStep1Controller : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic) int taskid;
@property (nonatomic) NSString *web_url;
@property (nonatomic) int goods_id;
@end
