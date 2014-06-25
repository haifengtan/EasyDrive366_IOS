//
//  Browser2Controller.h
//  EasyDrive366
//
//  Created by Steven Fu on 1/15/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Browser2Controller : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *browser_title;
@property (nonatomic) id article;
@end
