//
//  ShowDetailViewController.h
//  EasyDrive366
//
//  Created by Fu Steven on 8/27/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVUIGradientButton.h"
#import "BMapKit.h"


@interface ShowDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet NVUIGradientButton *btnNav;
@property (nonatomic) CLLocationCoordinate2D target;
-(void)loadData:(id)data;
@end
