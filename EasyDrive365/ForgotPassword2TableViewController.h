//
//  ForgotPassword2TableViewController.h
//  EasyDrive366
//  找回密码第二步
//  Created by admin on 14-7-31.
//  Copyright (c) 2014年 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomEditTableViewController.h"

@interface ForgotPassword2TableViewController : CustomEditTableViewController
/**验证码*/
@property (nonatomic) NSString *verificationCode;
/**新密码*/
@property (nonatomic) NSString *userPassword;
/**确认密码*/
@property (nonatomic) NSString *confirmPassword;
/**手机号*/
@property (nonatomic) NSString *userPhone;

@property (nonatomic) NSString *username;
@end
