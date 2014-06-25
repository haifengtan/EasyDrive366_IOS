//
//  TPKeyboardAvoidingScrollView.h
//  EasyDrive366
//
//  Created by Fu Steven on 9/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPKeyboardAvoidingScrollView : UIScrollView
- (BOOL)focusNextTextField;
- (void)scrollToActiveTextField;
@end
