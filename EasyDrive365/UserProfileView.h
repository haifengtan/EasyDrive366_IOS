//
//  UserProfileView.h
//  EasyDrive366
//
//  Created by Steven Fu on 12/19/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileView : UIView{
    UINavigationController *_parent;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageAvater;

@property (weak, nonatomic) IBOutlet UILabel *lblUsername;

@property (weak, nonatomic) IBOutlet UILabel *lblSignature;
@property (weak, nonatomic) IBOutlet UILabel *lblBound;
@property (weak, nonatomic) IBOutlet UIProgressView *pvExp;
@property (weak, nonatomic) IBOutlet UILabel *lblExp;


-(id)initWithController:(UINavigationController *)parent taskid:(int)taskid;
-(void)load_data:(int)taskid;
@end
