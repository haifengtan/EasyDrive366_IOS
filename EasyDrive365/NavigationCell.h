//
//  NavigationCell.h
//  EasyDrive365
//
//  Created by Fu Steven on 2/6/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationCell : UITableViewCell<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (nonatomic,copy) NSString *keyname;

@property (nonatomic,copy) NSString *phone;
@property (nonatomic) UINavigationController *rootController;
@property (weak, nonatomic) IBOutlet UIImageView *imgeIcon;


-(void)getLatest;
-(void)empty;
@end
