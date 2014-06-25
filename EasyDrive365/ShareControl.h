//
//  ShareControl.h
//  EasyDrive366
//
//  Created by Steven Fu on 2/5/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
@interface ShareControl : NSObject<UIActionSheetDelegate,MFMessageComposeViewControllerDelegate>

-(void)popupMenu:(NSString *)title introduce:(NSString *)introduce url:(NSString *)url;

@end
