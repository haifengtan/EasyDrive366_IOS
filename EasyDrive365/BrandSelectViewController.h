//
//  BrandSelectViewController.h
//  EasyDrive366
//
//  Created by admin on 14-7-29.
//  Copyright (c) 2014年 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#define HEADERVIEWHEIGHT 40

@interface BrandSelectViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UINib* nib;
    UINib* nib2;
    NSMutableArray* flags;
}
@property (weak, nonatomic) IBOutlet UITableView *carInfotableView;
/**所有车型信息*/
@property (nonatomic) id list;
/**车型号*/
@property (nonatomic) NSString *brand;
/**车型id*/
@property (nonatomic) NSString *brand_id;
/**所有分组后的车型信息*/
@property(strong,nonatomic) NSMutableArray* allCarsInfo;
@end
