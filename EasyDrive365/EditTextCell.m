//
//  EditTextCell.m
//  EasyDrive365
//
//  Created by Fu Steven on 3/2/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "EditTextCell.h"

@implementation EditTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setUnit:(NSString *)unit{
    CGRect old_frame= self.valueText.frame;
    self.valueText.frame = CGRectMake(old_frame.origin.x, old_frame.origin.y, old_frame.size.width-90, old_frame.size.height);
    self.lblUnit.text = unit;
}

-(void)onExit:(UITextField *)sender{
    if (self.delegate){
        [self.delegate exitEdit:self.key value:sender.text];
    }
}
-(void)textChanged:(id)sender{
    //NSLog(@"%@",sender);
    if (self.targetObject){
        self.targetObject[@"value"]=[(UITextField*)sender text];
    }
    if (self.delegate){
        [self.delegate valueChanged:self.key value:[(UITextField*)sender text]];
    }
}
-(void)textChanged2:(id)sender{

    if (self.targetObject){
        self.targetObject[self.key]=[(UITextField*)sender text];
    }
}
@end
