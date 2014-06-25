//
//  BoundHeader.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/19/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "BoundHeader.h"
#import "TaskListController.h"
@implementation BoundHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)buttonPressed:(id)sender {
    if (self.parent){
        TaskListController *vc =[[TaskListController alloc] initWithStyle:UITableViewStylePlain];
        [self.parent pushViewController:vc animated:YES];
    }
}

@end
