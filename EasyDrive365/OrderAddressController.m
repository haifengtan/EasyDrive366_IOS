//
//  OrderAddressController.m
//  EasyDrive366
//  配送信息页面
//  Created by Steven Fu on 1/28/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "OrderAddressController.h"
#import "AppSettings.h"
#import "OrderFinishedController.h"

@interface OrderAddressController (){
    BOOL _canChooseWantGetBySelf;
    UITextField *_txtName;
    UITextField *_txtPhone;
    UITextField *_txtAddress;

    UITextField *_txtA_Name;
    UITextField *_txtA_Phone;
    UITextField *_txtA_Address;
}

@end

@implementation OrderAddressController

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(finished)];
    _canChooseWantGetBySelf =[self.address_data[@"a_visible"] intValue]==1;
}
-(void)finished{
    //complete
    NSLog(@"%@",_address_data);
    if([@"" isEqualToString:_address_data[@"name"]]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"收件人不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
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
    NSString *url = [NSString stringWithFormat:@"order/order_address?userid=%d&orderid=%@&name=%@&phone=%@&address=%@&a_visible=%@&a_checked=%@&a_name=%@&a_phone=%@&a_address=%@",[AppSettings sharedSettings].userid,_address_data[@"order_id"], _address_data[@"name"],_address_data[@"phone"],_address_data[@"address"],_address_data[@"a_visible"],_address_data[@"a_checked"],_address_data[@"a_name"],_address_data[@"a_phone"],_address_data[@"a_address"]];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            OrderFinishedController *vc = [[OrderFinishedController alloc] initWithNibName:@"OrderFinishedController" bundle:Nil];
           /* vc.order_id = json[@"result"][@"order_id"];
            vc.content = json[@"result"][@"content"];
            */
            vc.content_data = json[@"result"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _canChooseWantGetBySelf?2:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0){
        return  3;
    }else{
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int topX = 14;
    if ([[AppSettings sharedSettings] isIos7]){
        topX = 4;
    }
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if (indexPath.section==0){
        if (indexPath.row==0){
            cell.textLabel.text= @"收件人";
            if (!_txtName){
                _txtName = [[UITextField alloc] initWithFrame:CGRectMake(100, topX, 200, 36)];
                [_txtName addTarget:self action:@selector(nameChanged:) forControlEvents:UIControlEventEditingChanged];
                _txtName.placeholder =@"收件人";
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
                _txtPhone = [[UITextField alloc] initWithFrame:CGRectMake(100, topX, 200, 36)];
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
                _txtAddress = [[UITextField alloc] initWithFrame:CGRectMake(100, topX, 200, 36)];
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

    }else{
        if (indexPath.row==0){
            cell.textLabel.text = @"选择自提";
            CGRect rect;
            if ([[AppSettings sharedSettings] isIos7]){
                rect = CGRectMake(250, 10, 50, 24);
            }else{
                rect = CGRectMake(220, 10, 50, 24);
            }
            UISwitch *sw = [[UISwitch alloc] initWithFrame:rect];
            sw.on = [self.address_data[@"a_checked"] intValue]==1;
            [cell.contentView addSubview:sw];
            [sw addTarget:self action:@selector(selectGetBySelf:) forControlEvents:UIControlEventValueChanged];
        }else if (indexPath.row==1){
            cell.textLabel.text= @"联系人";
            if (!_txtA_Name){
                _txtA_Name = [[UITextField alloc] initWithFrame:CGRectMake(100, topX, 200, 36)];
                [_txtA_Name addTarget:self action:@selector(anameChanged:) forControlEvents:UIControlEventEditingChanged];
                _txtA_Name.placeholder =@"联系人";
                _txtA_Name.returnKeyType = UIReturnKeyNext;
                _txtA_Name.clearButtonMode =UITextFieldViewModeAlways;
                [_txtA_Name addTarget:self action:@selector(acompleteName) forControlEvents:UIControlEventEditingDidEndOnExit];
            }
            _txtA_Name.text = _address_data[@"a_name"];
            [_txtA_Name removeFromSuperview];
            [cell.contentView addSubview:_txtA_Name];
            
        }else if (indexPath.row==2){
            cell.textLabel.text= @"手机";
            if (!_txtA_Phone){
                _txtA_Phone = [[UITextField alloc] initWithFrame:CGRectMake(100, topX, 200, 36)];
                [_txtA_Phone addTarget:self action:@selector(aphoneChanged:) forControlEvents:UIControlEventEditingChanged];
                _txtA_Phone.placeholder =@"手机";
                _txtA_Phone.returnKeyType = UIReturnKeyNext;
                _txtA_Phone.keyboardType = UIKeyboardTypeNamePhonePad;
                _txtA_Phone.clearButtonMode =UITextFieldViewModeAlways;
                [_txtA_Phone addTarget:self action:@selector(acompletePhone) forControlEvents:UIControlEventEditingDidEndOnExit];
            }
            _txtA_Phone.text = _address_data[@"a_phone"];
            [_txtA_Phone removeFromSuperview];
            [cell.contentView addSubview:_txtA_Phone];
        }else if (indexPath.row==3){
            cell.textLabel.text= @"地址";
            if (!_txtA_Address){
                _txtA_Address = [[UITextField alloc] initWithFrame:CGRectMake(100, topX, 200, 36)];
                [_txtA_Address addTarget:self action:@selector(aaddressChanged:) forControlEvents:UIControlEventEditingChanged];
                _txtA_Address.placeholder =@"地址";
                _txtA_Address.returnKeyType = UIReturnKeyDone;
                _txtA_Address.clearButtonMode =UITextFieldViewModeAlways;
                [_txtA_Address addTarget:self action:@selector(acompleteAddress) forControlEvents:UIControlEventEditingDidEndOnExit];
            }
            [_txtA_Address removeFromSuperview];
            _txtA_Address.text = _address_data[@"a_address"];
            [cell.contentView addSubview:_txtA_Address];
        }
    }
    
    
    return cell;
}
-(void)selectGetBySelf:(UISwitch *)sw{
    self.address_data[@"a_checked"]=sw.isOn?@"1":@"0";
}
-(void)nameChanged:(UITextField *)sender{
    self.address_data[@"name"]=sender.text;
}
-(void)phoneChanged:(UITextField *)sender{
    self.address_data[@"phone"]=sender.text;
}-(void)addressChanged:(UITextField *)sender{
    self.address_data[@"address"]=sender.text;
}
-(void)completeName{
    [_txtPhone becomeFirstResponder];
}
-(void)completePhone{
    [_txtAddress becomeFirstResponder];
}
-(void)completeAddress{
    if (_canChooseWantGetBySelf && [self.address_data[@"a_checked"] intValue]==0){
        [self finished];
        return;
    }
    if (_canChooseWantGetBySelf && [self.address_data[@"a_checked"] intValue]==1){
        [_txtA_Name becomeFirstResponder];
    }
}

-(void)anameChanged:(UITextField *)sender{
    self.address_data[@"a_name"]=sender.text;
}
-(void)aphoneChanged:(UITextField *)sender{
    self.address_data[@"a_phone"]=sender.text;
}-(void)aaddressChanged:(UITextField *)sender{
    self.address_data[@"a_address"]=sender.text;
}
-(void)acompleteName{
    [_txtA_Phone becomeFirstResponder];
}
-(void)acompletePhone{
    [_txtA_Address becomeFirstResponder];
}
-(void)acompleteAddress{
    [self.view endEditing:YES];
    [self finished];
}

@end
