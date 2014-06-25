//
//  TakePhotoViewController.h
//  EasyDrive366
//
//  Created by Fu Steven on 9/5/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakePhotoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) double latitude;
@property (nonatomic) double longtitude;

@end
