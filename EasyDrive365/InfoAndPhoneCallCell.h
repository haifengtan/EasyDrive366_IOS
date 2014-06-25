//
//  InfoAndPhoneCallCell.h
//  EasyDrive365
//
//  Created by Fu Steven on 2/22/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoAndPhoneCallCell : UITableViewCell<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *info;
@property (copy,nonatomic) NSString *phone;
@end
