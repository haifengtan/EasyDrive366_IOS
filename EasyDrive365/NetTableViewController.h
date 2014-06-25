//
//  NetTableViewController.h
//  EasyDrive365
//
//  Created by Fu Steven on 2/27/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpHelper.h"
#import "HttpClientDelegate.h"
#import "RefreshHelper.h"

@interface NetTableViewController : UITableViewController<HttpClientDelegate,RefreshHelperDelegate,UIScrollViewDelegate>{
    HttpHelper *_helper;
    NSString *_company;
    NSString *_phone;
    RefreshHelper *_refreshHelper;
}
@property (nonatomic) int taskid;
-(void)setup;
-(void)processData:(id)json;

@end
