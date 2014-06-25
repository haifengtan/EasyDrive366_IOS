//
//  Browser2Controller.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/15/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "Browser2Controller.h"
#import "ArticleCommentViewController.h"

@interface Browser2Controller ()<UIWebViewDelegate>

@end

@implementation Browser2Controller

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
    self.title = @"浏览";
    if (self.url){
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }else if (self.article){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看评论" style:UIBarButtonSystemItemFastForward target:self action:@selector(gotoShare)];
        NSString *_article_url;
        self.title = _article[@"title"];
        if ([_article[@"url"] hasPrefix:@"http://"]){
            _article_url = _article[@"url"];
        }else{
            _article_url = [NSString stringWithFormat:@"http://%@",_article[@"url"]];
        }
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_article_url]]];
    }
    if (self.browser_title){
        self.title = self.browser_title;
    }
    self.webView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBrowser:) name:REFRESH_BROWSER object:nil];
}

-(void)refreshBrowser:(NSNotification *)notification{
    NSString *url = notification.userInfo[@"url"];
    if (url && ![url isEqualToString:@""]){
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }else{
        [self.webView reload];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gotoShare{
    ArticleCommentViewController *vc = [[ArticleCommentViewController alloc] initWithNibName:@"ArticleCommentViewController" bundle:nil];
    vc.article = _article;
    [self.navigationController pushViewController:vc animated:YES];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    static NSString *callSchema = @"easydrive366";

    NSString *schema = request.URL.scheme;
    if ([callSchema isEqualToString:schema]){
        NSString *command_name = request.URL.host;
        NSString *query = request.URL.query;
        NSLog(@"query=%@",query);
        NSArray *arr = [query componentsSeparatedByString:@"&"];

        NSMutableDictionary *params =[NSMutableDictionary new];
        [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSArray *kv =[obj componentsSeparatedByString:@"="];
            NSLog(@"parameter=%@",kv);
            if (kv){
                [params setObject:kv[1] forKey:kv[0]];
            }
        }];

        NSLog(@"%@",params);
        [self process_command:command_name params:params];
        return NO;
    }
    return YES;
}
-(void)process_command:(NSString *)command params:(id)params{
    if ([command isEqualToString:@"open_page"]){
        NSString *url = params[@"url"];
        if (url && ![url isEqualToString:@""]){
            Browser2Controller *vc = [[Browser2Controller alloc] initWithNibName:@"Browser2Controller" bundle:nil];
            vc.url = url;
            vc.browser_title = params[@"title"];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
    }else if ([command isEqualToString:@"close_page"]){
        NSString *url = params[@"url"];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_BROWSER object:nil userInfo:@{@"url":url}];
        
    }
}
@end
