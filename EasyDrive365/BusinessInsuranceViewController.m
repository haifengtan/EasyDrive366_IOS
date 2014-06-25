//
//  BusinessInsuranceViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/14/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "BusinessInsuranceViewController.h"

#import "InsuranceDetailCell.h"
#import "InfoAndPhoneCallCell.h"
@interface BusinessInsuranceViewController ()
{
    NSArray *_headers;
    id result;
}
@end

@implementation BusinessInsuranceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addInsurance)];
    _headers=@[@"基本项目",@"合计"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableview:nil];
    [super viewDidUnload];
}

-(void)setup{
    _helper.url=[_helper appSetttings].url_get_suggestion_insurance;
}
-(void)processData:(id)json{
     NSLog(@"%@",json);
    result = json[@"result"];
    if (result[@"data"]){
            [self.tableview reloadData];
    }

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0){
        return  result?[result[@"data"] count]:0;
    }else{
        return  1;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (indexPath.section==0){
            NSArray *cells =[[NSBundle mainBundle] loadNibNamed:@"InsuranceDetailCell" owner:self.tableview options:nil];
            cell=[cells objectAtIndex:0];
        }else{
            NSArray *cells =[[NSBundle mainBundle] loadNibNamed:@"InfoAndPhoneCallCell" owner:self.tableview options:nil];
            cell=[cells objectAtIndex:0];
        }
    }
    
    
    if (indexPath.section==0){
        if (result){
            id item=[result[@"data"] objectAtIndex:indexPath.row];
            ((InsuranceDetailCell *)cell).itemLabel.text=item[@"item"];
            ((InsuranceDetailCell *)cell).field1.text= item[@"field1"];
            ((InsuranceDetailCell *)cell).field2.text= item[@"field2"];
        }
        
    }else{
        if (result){
            ((InfoAndPhoneCallCell *)cell).info.text = result[@"summary"];
            ((InfoAndPhoneCallCell *)cell).phone = result[@"phone"];
        }
        
    }
    
    
    
    return cell;
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_headers objectAtIndex:section];
}


@end
