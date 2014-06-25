//
//  NavigationViewController.h
//  EasyDrive366
//
//  Created by Fu Steven on 8/28/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKMapView.h"

@interface NavigationViewController : UIViewController

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (nonatomic) CLLocationCoordinate2D target;
@property (nonatomic) CLLocationCoordinate2D from;
@end
