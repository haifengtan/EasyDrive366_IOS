//
//  ShowLocationViewController.h
//  EasyDrive366
//
//  Created by Fu Steven on 8/26/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowLocationViewController : UIViewController

@property (nonatomic) Boolean isFull;
@property (nonatomic) id target_postion;
@property (nonatomic) id target_list;
-(void)goLocation:(CGFloat)latitude longtitude:(CGFloat)longtitude;
-(void)showMineLocation:(CGFloat)latitude longtitude:(CGFloat)longtitude;

-(void)showShop:(id)list;
-(void)showSingleShop:(id)shop;

@end
