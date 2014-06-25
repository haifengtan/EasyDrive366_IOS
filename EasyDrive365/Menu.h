//
//  Menu.h
//  EasyDrive365
//
//  Created by Fu Steven on 2/6/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Menu : NSObject

@property (nonatomic,retain) NSArray *list;
@property (nonatomic,retain) NSArray *insurance_list;
+(Menu *)sharedMenu;
-(NSString *)getTitleByKey:(NSString *)key;
-(void)pushToController:(UINavigationController *)controller key:(NSString *)key  title:(NSString *)title   url:(NSString *)url;
@end
