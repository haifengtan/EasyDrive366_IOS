//
//  ShowActivateTableController.h
//  EasyDrive366
//
//  Created by Fu Steven on 8/14/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowActivateTableController : UITableViewController
@property (nonatomic) id list;

-(void)setData:(NSString *)name code:(NSString *)code activate_date:(NSString *)activate_date valid_date:(NSString *)valid_date contents:(NSArray *)contents;
@end
