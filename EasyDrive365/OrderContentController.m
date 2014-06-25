//
//  OrderContentController.m
//  EasyDrive366
//
//  Created by Steven Fu on 2/19/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "OrderContentController.h"
#import "AppSettings.h"
#import "OrderFinishedController.h"

@interface OrderContentController (){
    UITextField *_txtName;
    UITextField *_txtId;
    UITextField *_txtPhone;
    UITextField *_txtAddress;
}

@end

@implementation OrderContentController

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
}
-(void)finished{
    //complete
    NSLog(@"%@",self.ins_data);
    if([@"" isEqualToString:self.ins_data[@"name"]]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"姓名不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    if([@"" isEqualToString:self.ins_data[@"idcard"]]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"身份证号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    if([@"" isEqualToString:self.ins_data[@"phone"]]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"手机号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    if([@"" isEqualToString:self.ins_data[@"address"]]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"地址不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *url = [NSString stringWithFormat:@"order/order_ins_content?userid=%d&orderid=%@&name=%@&idcard=%@&phone=%@&address=%@",[AppSettings sharedSettings].userid,self.ins_data[@"order_id"], self.ins_data[@"name"],self.ins_data[@"idcard"],self.ins_data[@"phone"],self.ins_data[@"address"]];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            OrderFinishedController *vc = [[OrderFinishedController alloc] initWithNibName:@"OrderFinishedController" bundle:Nil];
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

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
            [_txtName addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
            _txtName.placeholder =@"姓名";
            _txtName.returnKeyType = UIReturnKeyNext;
            _txtName.clearButtonMode =UITextFieldViewModeAlways;
            _txtName.tag =0;
            [_txtName addTarget:self action:@selector(completeValue:) forControlEvents:UIControlEventEditingDidEndOnExit];
        }
        _txtName.text = self.ins_data[@"name"];
        [_txtName removeFromSuperview];
        [cell.contentView addSubview:_txtName];
        
    }else if (indexPath.row==1){
        cell.textLabel.text= @"身份证号";
        if (!_txtId){
            _txtId = [[UITextField alloc] initWithFrame:CGRectMake(100, 4, 200, 36)];
            [_txtId addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
            _txtId.placeholder =@"身份证号";
            _txtId.returnKeyType = UIReturnKeyNext;
            _txtId.keyboardType = UIKeyboardTypeNamePhonePad;
            _txtId.clearButtonMode =UITextFieldViewModeAlways;
            _txtId.tag =1;
            [_txtId addTarget:self action:@selector(completeValue:) forControlEvents:UIControlEventEditingDidEndOnExit];
        }
        _txtId.text = self.ins_data[@"idcard"];
        [_txtId removeFromSuperview];
        [cell.contentView addSubview:_txtId];
    }else if (indexPath.row==2){
        cell.textLabel.text= @"手机";
        if (!_txtPhone){
            _txtPhone = [[UITextField alloc] initWithFrame:CGRectMake(100, 4, 200, 36)];
            [_txtPhone addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
            _txtPhone.placeholder =@"手机";
            _txtPhone.returnKeyType = UIReturnKeyNext;
            _txtPhone.keyboardType = UIKeyboardTypeNamePhonePad;
            _txtPhone.clearButtonMode =UITextFieldViewModeAlways;
            _txtPhone.tag=2;
            [_txtPhone addTarget:self action:@selector(completeValue:) forControlEvents:UIControlEventEditingDidEndOnExit];
        }
        _txtPhone.text = self.ins_data[@"phone"];
        [_txtPhone removeFromSuperview];
        [cell.contentView addSubview:_txtPhone];
    }else{
        cell.textLabel.text= @"地址";
        if (!_txtAddress){
            _txtAddress = [[UITextField alloc] initWithFrame:CGRectMake(100, 4, 200, 36)];
            [_txtAddress addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
            _txtAddress.placeholder =@"地址";
            _txtAddress.returnKeyType = UIReturnKeyDone;
            _txtAddress.clearButtonMode =UITextFieldViewModeAlways;
            _txtAddress.tag=3;
            [_txtAddress addTarget:self action:@selector(completeValue:) forControlEvents:UIControlEventEditingDidEndOnExit];
        }
        [_txtAddress removeFromSuperview];
        _txtAddress.text = self.ins_data[@"address"];
        [cell.contentView addSubview:_txtAddress];
    }
    
    return cell;
}

-(void)valueChanged:(UITextField *)sender{
    int index = sender.tag;
    self.ins_data[@[@"name",@"idcard",@"phone",@"address"][index]]= sender.text;
}
-(void)completeValue:(UITextField *)sender{
    int index = sender.tag;
    if (index<3){
        [@[_txtId,_txtPhone,_txtAddress][index] becomeFirstResponder];
    }else{
        [self finished];
    }
    
}
@end
