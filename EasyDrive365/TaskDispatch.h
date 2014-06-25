//
//  TaskDispatch.h
//  EasyDrive366
//
//  Created by Steven Fu on 2/19/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskDispatch : NSObject
-(id)initWithController:(UINavigationController *)controller task:(id)task;

-(void)pushToController;

@end
