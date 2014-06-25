//
//  HttpHelper.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/17/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "HttpHelper.h"


@implementation HttpHelper
@synthesize delegate =_delegate;
@synthesize url=_url;

-(id)initWithTarget:(id<HttpClientDelegate>)target{
    self =[super init];
    if (self){
        _delegate = target;
    }
    return self;
}
-(void)setUrl:(NSString *)url{
    if (self.delegate && [self.delegate taskid]>0){
        _url =[NSString stringWithFormat:@"%@&taskid=%d",url,[self.delegate taskid]];
    }else{
        _url = url;
    }
}
-(void)loadData{
    [self loadData:0];
}
-(void)loadData:(int)reload{
    
    [self.delegate setup];
    //not setup _url;
    if (!_url){
        return;
    }
    
    // test offline
    if (![HttpClient sharedHttp].isInternet){
        id json= [[AppSettings sharedSettings] loadJsonBy:NSStringFromClass([self.delegate class])];
        [self.delegate processData:json];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@&reload=%d",_url,reload];
    NSLog(@"Reload url=%@",url);
    [[HttpClient sharedHttp] get:url block:^(id json) {
       
        if ([[AppSettings sharedSettings] isSuccess:json]){
            
            [[AppSettings sharedSettings] saveJsonWith:NSStringFromClass( [self.delegate class]) data:json];
            [self.delegate processData:json];
            
        }else{
            //get nothing from server;
            [self.delegate responseError:json];
        }
    }];
}
-(void)restoreData{
    id json= [[AppSettings sharedSettings] loadJsonBy:NSStringFromClass([self.delegate class])];
    if (json){
        [self.delegate processData:json];
    }

}

-(HttpClient *)httpClient{
    return [HttpClient sharedHttp];
}

-(AppSettings *)appSetttings{
    return [AppSettings sharedSettings];
}
@end
