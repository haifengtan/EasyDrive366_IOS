//
//  AppSettings.h
//  Learn ActivityViewController
//
//  Created by Fu Steven on 1/30/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "ShareControl.h"

@interface Information:NSObject
@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) NSString *company;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *latest;

@property (nonatomic,strong) NSString *updateTime;
-(void)setDataFromJsonWithKey:(id)json key:(NSString *)key;

@end

@interface AppSettings : NSObject<NSCoding,UIAlertViewDelegate>{
    NSMutableDictionary *_dict;
    BOOL _needset;
    NSString *_needsetmsg;
    BOOL *_isUpdating;
    ShareControl *_sharecontrol;
}

@property (nonatomic,retain) NSString *firstName;
@property (nonatomic,retain) NSString *lastName;
@property (nonatomic) BOOL isLogin;
@property (nonatomic) BOOL isFirst;
@property (nonatomic) int userid;
@property (nonatomic,retain) NSString *deviceToken;

@property (nonatomic,retain) NSMutableDictionary *local_data;
@property (nonatomic,retain) NSMutableArray *list;
@property (nonatomic,retain) id latest_news;
@property (nonatomic) BOOL isNeedRefresh;
@property (nonatomic) BOOL isCancelUpdate;
@property (nonatomic) id version;
@property (nonatomic,weak) HttpClient *http;

+(AppSettings *)sharedSettings;


-(void)save;

//local data process
-(void)saveJsonWith:(NSString *)className data:(id)data;
-(id)loadJsonBy:(NSString *)className;

//http process
-(BOOL)isSuccess:(id)json;
-(NSString *)url_for_get_news;
-(NSString *)url_for_get_helpcalls;

-(NSString *)url_for_get_check_helpcalls;
-(NSString *)url_for_get_vender:(NSString *)code;
-(NSString *)url_for_get_note:(NSString *)code;


-(NSString *)url_for_rescue;
-(NSString *)url_for_illegallys;
-(NSString *)url_for_insurance_list;
-(NSString *)url_for_maintain_list;

-(NSString *)url_for_post_maintain_record;
-(NSString *)url_for_get_maintain_record;

-(NSString *)url_getlatest:(NSString *)keyname;

-(NSString *)url_get_driver_license;
-(NSString *)url_get_car_registration;

-(NSString *)url_get_suggestion_insurance;
-(NSString *)url_get_license_type;

-(NSString *)url_get_business_insurance;
-(NSString *)url_get_count_of_suggestions;

-(NSString *)url_change_password:(NSString *)newPassword oldPassword:(NSString *)oldPassword;

-(NSString *)udid;


-(void)register_device_token;
-(void)login:(NSString *)username userid:(int)userid;
-(void)makeCall:(NSString *)phone;
-(void)get_latest;
-(void)get_insurance_latest;
-(Information *)getInformationByKey:(NSString *)key;

-(void)add_login:(NSString *)username password:(NSString *)password rememberPassword:(NSString *)rememberPassword;
-(NSMutableArray *)get_logins;

-(void)check_update:(BOOL)inSettings;
-(void)login:(NSString *)username password:(NSString *)password remember:(NSString *)remember callback:(void (^)(BOOL loginSuccess))callback;
-(BOOL)isIos7;
-(UITabBarController *)tabBarController;

+(NSString *)getStringDefault:(id)item default:(NSString *)d;


-(void)pay:(NSString *)name description:(NSString *)description amount:(CGFloat)amount order_no:(NSString *)order_no;

-(void)popupShareMenu:(NSString *)title introduce:(NSString *)introduce url:(NSString *)url;
@end
