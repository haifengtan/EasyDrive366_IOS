//
//  InsuranceStep7Controller.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/27/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "InsuranceStep7Controller.h"
#import "AppSettings.h"
#import "InsuranceStep8Controller.h"
@interface InsuranceStep7Controller (){
    id _address_data;
    UITextField *_txtName;
    UITextField *_txtPhone;
    UITextField *_txtAddress;
}

@end

@implementation InsuranceStep7Controller

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"配送信息";
 
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"第五步" style:UIBarButtonItemStyleBordered target:self action:@selector(backStep5)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(completeAddress)];
    [self load_data];
}
-(void)backStep5{
    UINavigationController *vc = [self.navigationController.viewControllers objectAtIndex:6];
    [self.navigationController popToViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)load_data{
    NSString *url = [NSString stringWithFormat:@"ins/carins_address?userid=%d&orderid=%@&bounds=%@&bankid=%@&account=%@",[AppSettings sharedSettings].userid,self.orderid,self.bounds,self.bankid,self.account];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _address_data = json[@"result"];
            [self.tableView reloadData];
        }
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if (indexPath.row==0){
        cell.textLabel.text= @"姓名";
        if (!_txtName){
            _txtName = [[UITextField alloc] initWithFrame:CGRectMake(100, 4, 200, 36)];
            [_txtName addTarget:self action:@selector(nameChanged:) forControlEvents:UIControlEventEditingChanged];
            _txtName.placeholder =@"姓名";
            _txtName.returnKeyType = UIReturnKeyNext;
            _txtName.clearButtonMode =UITextFieldViewModeAlways;
            [_txtName addTarget:self action:@selector(completeName) forControlEvents:UIControlEventEditingDidEndOnExit];
        }
        _txtName.text = _address_data[@"name"];
        [_txtName removeFromSuperview];
        [cell.contentView addSubview:_txtName];
        
    }else if (indexPath.row==1){
        cell.textLabel.text= @"手机";
        if (!_txtPhone){
            _txtPhone = [[UITextField alloc] initWithFrame:CGRectMake(100, 4, 200, 36)];
            [_txtPhone addTarget:self action:@selector(phoneChanged:) forControlEvents:UIControlEventEditingChanged];
            _txtPhone.placeholder =@"手机";
            _txtPhone.returnKeyType = UIReturnKeyNext;
            _txtPhone.keyboardType = UIKeyboardTypeNamePhonePad;
            _txtPhone.clearButtonMode =UITextFieldViewModeAlways;
            [_txtPhone addTarget:self action:@selector(completePhone) forControlEvents:UIControlEventEditingDidEndOnExit];
        }
        _txtPhone.text = _address_data[@"phone"];
        [_txtPhone removeFromSuperview];
        [cell.contentView addSubview:_txtPhone];
    }else{
        cell.textLabel.text= @"地址";
        if (!_txtAddress){
            _txtAddress = [[UITextField alloc] initWithFrame:CGRectMake(100, 4, 200, 36)];
            [_txtAddress addTarget:self action:@selector(addressChanged:) forControlEvents:UIControlEventEditingChanged];
            _txtAddress.placeholder =@"地址";
            _txtAddress.returnKeyType = UIReturnKeyDone;
            _txtAddress.clearButtonMode =UITextFieldViewModeAlways;
            [_txtAddress addTarget:self action:@selector(completeAddress) forControlEvents:UIControlEventEditingDidEndOnExit];
        }
        [_txtAddress removeFromSuperview];
        _txtAddress.text = _address_data[@"address"];
        [cell.contentView addSubview:_txtAddress];
    }
    
    return cell;
}
-(void)nameChanged:(UITextField *)sender{
    _address_data[@"name"]=sender.text;
}
-(void)phoneChanged:(UITextField *)sender{
    _address_data[@"phone"]=sender.text;
}-(void)addressChanged:(UITextField *)sender{
    _address_data[@"address"]=sender.text;
}
-(void)completeName{
    [_txtPhone becomeFirstResponder];
}
-(void)completePhone{
    [_txtAddress becomeFirstResponder];
}
-(void)completeAddress{
    [self.view endEditing:YES];
    NSLog(@"%@",_address_data);
    if([@"" isEqualToString:_address_data[@"name"]]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"姓名不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    if([@"" isEqualToString:_address_data[@"phone"]]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"手机号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    if([@"" isEqualToString:_address_data[@"address"]]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"地址不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *url = [NSString stringWithFormat:@"ins/carins_upload?userid=%d&name=%@&phone=%@&address=%@",[AppSettings sharedSettings].userid,_address_data[@"name"],_address_data[@"phone"],_address_data[@"address"]];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            InsuranceStep8Controller *vc = [[InsuranceStep8Controller alloc] initWithStyle:UITableViewStyleGrouped];
            vc.upload_data = json[@"result"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

@end
