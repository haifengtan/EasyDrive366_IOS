//
//  AppSettings.m
//  Learn ActivityViewController
//
//  Created by Fu Steven on 1/30/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "AppSettings.h"
#import "Menu.h"
#import "MenuItem.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"
#import "AlixLibService.h"
#import "AppDelegate.h"


@implementation Information
-(void)setDataFromJsonWithKey:(id)json key:(NSString *)key{
    if (json[@"result"]){
        self.company = json[@"result"][@"company"];
        self.phone =json[@"result"][@"phone"];
        self.latest =json[@"result"][@"latest"];
        self.updateTime =json[@"result"][@"updated_time"];
    }
}
@end


@interface AppSettings(){
    SEL _result;
}

@end
@implementation AppSettings
@synthesize firstName=_firstName;
@synthesize lastName=_lastName;
@synthesize isLogin = _isLogin;
@synthesize userid=_userid;
@synthesize deviceToken=_deviceToken;
@synthesize list = _list;
@synthesize latest_news =_latest_news;
@synthesize local_data =_local_data;


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self =[super init];
    if (self)
    {
        _firstName = [aDecoder decodeObjectForKey:@"firstname"];
        _lastName =[aDecoder decodeObjectForKey:@"lastname"];
        _isLogin =[aDecoder decodeBoolForKey:@"isLogin"];
        _isFirst =[aDecoder decodeBoolForKey:@"isFirst"];
        _userid =[aDecoder decodeInt32ForKey:@"userid"];
        _list =[aDecoder decodeObjectForKey:@"list"];
        _latest_news =[aDecoder decodeObjectForKey:@"latest_news"];
        _local_data =[aDecoder decodeObjectForKey:@"local_data"];
        _deviceToken =[aDecoder decodeObjectForKey:@"device_token"];
        _dict = [[NSMutableDictionary  alloc] init];

        [self init_latest];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_firstName forKey:@"firstname"];
    [aCoder encodeObject:_lastName forKey:@"lastname"];
    [aCoder encodeBool:_isLogin forKey:@"isLogin"];
    [aCoder encodeBool:_isFirst forKey:@"isFirst"];
    [aCoder encodeInt32:_userid forKey:@"userid"];
    [aCoder encodeObject:_list forKey:@"list"];
    [aCoder encodeObject:_latest_news forKey:@"latest_news"];
    [aCoder encodeObject:_local_data forKey:@"local_data"];
    [aCoder encodeObject:_deviceToken forKey:@"device_token"];

}

-(id)init{
    self = [super init];
    if (self){
        _dict = [[NSMutableDictionary  alloc] init];
        _isFirst = YES;
        [self init_latest];
    }
    return self;
}

+(AppSettings *)sharedSettings
{
    static AppSettings *_instance;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        //_instance = [[AppSettings alloc] init];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSData *userDefaultData =[userDefault objectForKey:NSStringFromClass([self class])];
        if (userDefaultData){
            _instance =[NSKeyedUnarchiver unarchiveObjectWithData:userDefaultData];
        }else{
            _instance =[[AppSettings alloc] init];
        }
        
    });
    return _instance;
}


-(HttpClient *)http{
    return [HttpClient sharedHttp];
}
- (void)save{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    [userDefault setObject:udObject forKey:NSStringFromClass([self class])];
    [userDefault synchronize];
    
}
//local data process
-(void)saveJsonWith:(NSString *)className data:(id)data{
    if (!_local_data){
        _local_data =[[NSMutableDictionary alloc] init];
        
    }
    id item =@{@"date" : [NSDate date],@"data":data};
    [_local_data setObject:item forKey:[self jsonKey:className]];
    [self save];

}
-(id)loadJsonBy:(NSString *)className{
    if (_local_data){
        return [[_local_data objectForKey:[self jsonKey:className]] objectForKey:@"data"];
    }else{
        return nil;
    }
}
-(NSString *)jsonKey:(NSString *)className{
    return [NSString stringWithFormat:@"%@_by_%d",className,self.userid];
}


-(void)setDeviceToken:(NSString *)deviceToken{
  
    _deviceToken=[[deviceToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken=%@",_deviceToken);
    [self register_device_token];
}
-(void)register_device_token
{
    if (self.userid && self.userid>0 && _deviceToken){
        HttpClient *http = [HttpClient sharedHttp];
        NSString *url = [NSString stringWithFormat:@"pushapi/add_device?userid=%d&device_token=%@&udid=%@",self.userid,_deviceToken,[self udid]];
        [http get:url block:^(id json) {
            NSLog(@"%@",json);
        }];
    }
}
-(void)login:(NSString *)username userid:(int)userid{
    self.userid = userid;
    self.firstName = username;
    self.isLogin = YES;
    [self save];
    [self register_device_token];
    self.isNeedRefresh=YES;
}
//http process
-(BOOL)isSuccess:(id)json
{
    return [[json objectForKey:@"status"] isEqualToString:@"success"];
}
-(NSString *)url_for_get_news
{
    return [NSString stringWithFormat:@"api/get_news?userid=%d",self.userid];
}
-(NSString *)url_for_get_helpcalls
{
    return [NSString stringWithFormat:@"api/get_helps?userid=%d",self.userid];
}
-(NSString *)url_for_get_check_helpcalls
{
    return [NSString stringWithFormat:@"api/get_check_helps?userid=%d",self.userid];
}
-(NSString *)url_for_get_vender:(NSString *)code{
    return [NSString stringWithFormat:@"api/get_help_service?userid=%d&code=%@",self.userid,code];
}
-(NSString *)url_for_get_note:(NSString *)code{
    return [NSString stringWithFormat:@"api/get_help_note?userid=%d&code=%@",self.userid,code];
}
-(NSString *)url_for_rescue{
    return [NSString stringWithFormat:@"api/get_rescues?userid=%d",self.userid];
}

-(NSString *)url_for_illegallys{
    return [NSString stringWithFormat:@"api/get_illegally_list?userid=%d",self.userid];
}
-(NSString *)url_for_insurance_list{
    return [NSString stringWithFormat:@"api/get_insurance_process_list?userid=%d",self.userid];
}

-(NSString *)url_for_maintain_list{
    return [NSString stringWithFormat:@"api/get_car_maintain_list?userid=%d",self.userid];
}

-(NSString *)url_for_post_maintain_record{
    return [NSString stringWithFormat:@"api/add_maintain_record?user_id=%d",self.userid];
}
-(NSString *)url_for_get_maintain_record{
    return [NSString stringWithFormat:@"api/get_maintain_record?userid=%d",self.userid];
}
-(NSString *)url_getlatest:(NSString *)keyname{
    return [NSString stringWithFormat:@"api/get_latest?userid=%d&keyname=%@",self.userid,keyname];
}

-(NSString *)url_get_driver_license{
    return [NSString stringWithFormat:@"api/get_driver_license?userid=%d",self.userid];
}
-(NSString *)url_get_car_registration{
    return [NSString stringWithFormat:@"api/get_car_registration?userid=%d",self.userid];
}

-(NSString *)url_get_suggestion_insurance{
    return [NSString stringWithFormat:@"api/get_suggestion_of_insurance?userid=%d",self.userid];
}

-(NSString *)url_get_license_type{
    return @"api/get_license_type?userid=1";
}


-(NSString *)url_get_business_insurance{
    return [NSString stringWithFormat:@"api/get_Policys?userid=%d",self.userid];
}

-(NSString *)url_get_count_of_suggestions{
    return [NSString stringWithFormat:@"api/get_count_of_suggestion?userid=%d",self.userid];
}

-(NSString *)url_change_password:(NSString *)newPassword  oldPassword:(NSString *)oldPassword{
    return [NSString stringWithFormat:@"api/reset_user_pwd?userid=%d&oldpwd=%@&newpwd=%@",self.userid,oldPassword,newPassword];
}

-(NSString *)udid{
    /*
    UIDevice *device =[UIDevice currentDevice];
    
    NSString *ident = nil;
    if ([device respondsToSelector:@selector(identifierForVendor)]) {
        ident = [device.identifierForVendor UUIDString];
    } else {
        ident = device.uniqueIdentifier;
    }
    return ident;
     */
    return @"";
}

-(void)makeCall:(NSString *)phone{
    if (phone){
        NSString *phoneNumber = [@"tel://" stringByAppendingString:phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
}


-(void)init_latest{
    for(int i=1;i<APPLATEST_COUNT;i++){
        NSString *key = [NSString stringWithFormat:@"%02d",i];
        Information *infor = [[Information alloc] init];
        id json = [self loadJsonBy:[NSString stringWithFormat:@"NavigationCell_%@",key]];
        //NSLog(@"%@",json);
        if (json){
            [infor setDataFromJsonWithKey:json key:key];
        }
        [_dict setObject:infor forKey:key];
    }
}
-(void)get_latest{
    /*
    if (!self.isLogin){
        return;
    }
     */
    self.isNeedRefresh= NO;
    /*
    for(int i=1;i<=APPLATEST_COUNT;i++){
        NSString *keyname = [NSString stringWithFormat:@"%02d",i];
        [self get_latest_by_key:keyname];
    }
     */
    for (MenuItem *item in [Menu sharedMenu].list) {
        [self get_latest_by_key:item.name];
    }
}
-(void)get_insurance_latest{
    /*
     if (!self.isLogin){
     return;
     }
     */
    self.isNeedRefresh= NO;
    /*
     for(int i=1;i<=APPLATEST_COUNT;i++){
     NSString *keyname = [NSString stringWithFormat:@"%02d",i];
     [self get_latest_by_key:keyname];
     }
     */
    for (MenuItem *item in [Menu sharedMenu].insurance_list) {
        [self get_latest_by_key:item.name];
    }
}
-(void)get_latest_by_key:(NSString *)keyname{
    NSString *url = [self url_getlatest:keyname];
    [[HttpClient sharedHttp] get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM-dd"];
            json[@"result"][@"updated_time"]=[formatter stringFromDate:[NSDate date]];
           // NSLog(@"%@",keyname);
            [[AppSettings sharedSettings] saveJsonWith:[NSString stringWithFormat:@"NavigationCell_%@",keyname]data:json];
            Information *infor =[_dict objectForKey:keyname];
            if (!infor){
                infor =[[Information alloc] init];
            }
            [infor setDataFromJsonWithKey:json key:keyname];
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"NavigationCell_%@",keyname] object:infor];
            
        }else{
            NSLog(@"%@",json);
            //get nothing from server;
        }
    }];
}
-(Information *)getInformationByKey:(NSString *)key{
    //NSLog(@"%@",_dict);
    return [_dict objectForKey:key];
}

-(void)add_login:(NSString *)username password:(NSString *)password rememberPassword:(NSString *)rememberPassword{
    if (!_list){
        _list = [[NSMutableArray alloc] init];
    }
    
    for (id item in _list) {
        NSString *uname =item[@"username"];
        if ([uname isEqualToString:username]){
            [_list removeObject:item];
            break;
        }
    }
    id item = @{@"username":username,@"password":password,@"remember":rememberPassword};
    [_list addObject:item];
    NSLog(@"%@",_list);
    [self save];
}
-(NSMutableArray *)get_logins{
    if (!_list){
        _list = [[NSMutableArray alloc] init];
    }
    return _list;
}
-(void)check_update:(BOOL)inSettings{
    if (inSettings){
        _isCancelUpdate = NO;
        _isUpdating=NO;
    }
    if (_isCancelUpdate){
        return;
    }
    if (_isUpdating){
        return;
    }
    _needset=NO;
    NSString *url = [NSString stringWithFormat:@"api/get_ver?ver=%@&device=iphone&userid=%d",AppVersion,self.userid];
    [self.http get:url block:^(id json) {
        if ([self isSuccess:json]){

            NSString *oldVersion = [NSString stringWithFormat:@"%@",AppVersion];
            _version= json[@"result"];
            if (!inSettings){
                _needset = [_version[@"needset"] boolValue];
               // _needset = YES;
            }
            
            _needsetmsg =_version[@"needsetmsg"];
            
            if (![oldVersion isEqual:_version[@"ver"]]){
                NSString *msg = _version[@"msg"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:AppTitle message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                [alertView show];
            }else{
                if (inSettings){
                    NSString *msg = _version[@"msg"];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:AppTitle message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                }else{
                    if (_needset){
                        _needset=NO;
                        [[NSNotificationCenter defaultCenter] postNotificationName:NEED_SET object:_needsetmsg];
                    }
                }
                
            }
            
        }
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d",buttonIndex);
    if (buttonIndex==1){
        _isUpdating=YES;
        NSString *url = _version[@"ios"];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
       
    }else {
        _isCancelUpdate  = YES;
    }
    if (_needset){
        _needset=NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:NEED_SET object:_needsetmsg];
    }
    
}
- (void)login:(NSString *)username password:(NSString *)password remember:(NSString *)remember callback:(void (^)(BOOL loginSuccess))callback{
    //[self doLogin];
    NSString *path  =[NSString stringWithFormat:@"api/login?username=%@&password=%@",username,password];
    NSLog(@"%@",path);
    [[HttpClient sharedHttp] get:path block:^(id json) {
        if (json){
            NSString *status =[json objectForKey:@"status"];
            if (status && [status isEqualToString:@"success"]){
                //success login
                
                NSNumber *userid=[[json objectForKey:@"result"] objectForKey:@"id"];
                
                [self login:username userid:[userid intValue]];
                [self add_login:username password:password rememberPassword:remember];

                [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS object:nil];
                if (callback){
                    callback(YES);
                }
                
            }
        }
    }];
    
}
-(BOOL)isIos7{
    //return [[[UIDevice currentDevice] systemVersion]  compare: @"6.2"]==NSOrderedDescending;
    return [[[UIDevice currentDevice] systemVersion] hasPrefix:@"7."];
}

-(UITabBarController *)tabBarController{
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).tabbarController;
}
+(NSString *)getStringDefault:(id)item default:(NSString *)d{
    NSLog(@"item=%@,class is %@",item,[item class]);
    if (item==nil)
        return d;
    if ([item isKindOfClass:[NSNull class]])
        return d;
    NSString *result =[NSString stringWithFormat:@"%@",item];
    if ([result isEqualToString:@""])
        return d;
    return result;
}

-(void)pay:(NSString *)name description:(NSString *)description amount:(CGFloat)amount order_no:(NSString *)order_no{
    
   // amount = 0.01;
    
    
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    order.tradeNO = order_no;//[self generateTradeNO];//订单ID（由商家自行制定）
	order.productName = name; //商品标题
	order.productDescription = description; //商品描述
	order.amount = [NSString stringWithFormat:@"%0.2f",amount];//商品价格
	order.notifyURL =  @"http%3A%2F%2Fm.4006678888.com:21000/index.php/paylog/noti_action"; //回调URL
    order.returnUrl =  @"http%3A%2F%2Fm.4006678888.com:21000/index.php/paylog/return_action"; //回调URL
    order.showUrl = @"http%3A%2F%2Fm.4006678888.com:21000/index.php/paylog/show_action"; //回调URL
    
    NSString *appScheme = APP_SCHEMA;
    NSString* orderInfo = [order description];
    NSString* signedStr = [self doRsa:orderInfo];

    NSLog(@"%@",signedStr);

    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                         orderInfo, signedStr, @"RSA"];

    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:_result target:self];

}


- (NSString *)generateTradeNO
{
	const int N = 15;
	
	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *result = [[NSMutableString alloc] init] ;
	srand(time(0));
	for (int i = 0; i < N; i++)
	{
		unsigned index = rand() % [sourceString length];
		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
		[result appendString:s];
	}
	return result;
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

-(void)popupShareMenu:(NSString *)title introduce:(NSString *)introduce url:(NSString *)url;{
    if (!_sharecontrol){
        _sharecontrol = [[ShareControl alloc] init];
    }
    [_sharecontrol popupMenu:title introduce:introduce url:url];
}
@end
