//
//  InfromationDetailViewController.h
//  EasyDrive366
//
//  Created by Fu Steven on 6/7/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfromationDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtContent;

-(void)loadInformation:(NSString *)information_id;
@end
