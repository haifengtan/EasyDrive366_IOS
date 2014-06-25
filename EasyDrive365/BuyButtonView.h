//
//  BuyButtonView.h
//  EasyDrive366
//
//  Created by Steven Fu on 1/22/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BuyButtonView;

@protocol BuyButtonViewDelegate
-(void)buyButtonPressed:(BuyButtonView *)sender data:(id)data;
@end
@interface BuyButtonView : UIView
@property (weak, nonatomic) IBOutlet UIButton *btnBuy;
@property (nonatomic) id<BuyButtonViewDelegate> delegate;
@property (nonatomic) id data;
@end
