//
//  FeedbackInputCell.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/5/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "FeedbackInputCell.h"
#import <QuartzCore/QuartzCore.h>
@interface FeedbackInputCell()<UITextViewDelegate>
@end

@implementation FeedbackInputCell

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
-(void)setupPhone:(NSString *)phone{
    self.txtPhone.text = phone;
    self.btnOK.text = @"确定";
    //self.lblLeft.text = [NSString stringWithFormat:@"还可以输入%d个字",200];
    [self textViewDidChange:self.txtContent];
    self.txtContent.layer.borderWidth = 2.0f;
    self.txtContent.layer.borderColor = [[UIColor grayColor] CGColor];
    self.txtContent.delegate= self;
    
    
}
- (IBAction)buttonPressed:(id)sender {
    if (self.delegate){
        [self.delegate feedback:self.txtContent.text phone:self.txtPhone.text];
    }
}
-(void)textViewDidChange:(UITextView *)textView{
    int count = 200- textView.text.length;
    self.lblLeft.text= [NSString stringWithFormat:@"还可以输入%d个字",count];
    if (textView.text.length>=200){
        [textView resignFirstResponder];
        
        
    }

}
@end
