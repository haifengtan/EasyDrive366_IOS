//
//  CustomEditTableViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 3/8/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "CustomEditTableViewController.h"
#import "IntroduceCell.h"
#import "EditTextCell.h"
#import "OneButtonCell.h"
#import "SwitchCell.h"
#import "ChooseNextCell.h"
#import "DatePickerViewController.h"
#import "LicenseTypeViewController.h"
#import "PickupData.h"
#import "TextLabelCell.h"
#import "ChooseNextImageCell.h"

@interface CustomEditTableViewController ()<UITextFieldDelegate,SwitchCellDelegate,OneButtonCellDelegate,PickupData,EditTextCellTextChanged>{
    UITextField *_lastTextField;
    int textfield_count;
}

@end

@implementation CustomEditTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)init_setup{
    _saveButtonName =@"登录";
}
- (void)viewDidLoad
{
    [self init_setup];
    [super viewDidLoad];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOn:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [self.navigationController setNavigationBarHidden:NO];
 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:_saveButtonName style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    [self initData];
}
-(void)initData{
    /*
    id items=@[
    @{@"key" :@"username",@"label":@"用户名：",@"default":@"",@"placeholder":@"" },
    @{@"key" :@"password",@"label":@"密码：",@"default":@"",@"placeholder":@"" },
    @{@"key" :@"repassword",@"label":@"再输一遍：",@"default":@"",@"placeholder":@"" }
    ];
    _list=[NSMutableArray arrayWithArray: @[
           @{@"count" : @1,@"cell":@"IntroduceCell",@"list":@[],@"height":@100.0f},
           @{@"count" : @5,@"cell":@"EditTextCell",@"list":items,@"height":@44.0f},
           @{@"count" : @1,@"cell":@"OneButtonCell",@"list":@[],@"height":@44.0f}
           ]];
    
    */
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [_list count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_list objectAtIndex:section][@"count"] intValue];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[_list objectAtIndex:indexPath.section][@"height"] intValue];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil){
        NSString *cellCalssName = [[_list objectAtIndex:indexPath.section][@"list"] objectAtIndex:indexPath.row][@"cell"];
        NSLog(@"%@",cellCalssName);
        if ([cellCalssName isEqualToString:@"default"]){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }else{
            cell= [[[NSBundle mainBundle] loadNibNamed:cellCalssName owner:nil options:nil] objectAtIndex:0];
        }
    
       
    }*/
    UITableViewCell *cell;
    
    NSString *cellCalssName = [[_list objectAtIndex:indexPath.section][@"list"] objectAtIndex:indexPath.row][@"cell"];

    if ([cellCalssName isEqualToString:@"default"]){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }else{
        cell= [[[NSBundle mainBundle] loadNibNamed:cellCalssName owner:nil options:nil] objectAtIndex:0];
    }
    
    [self setupCell:cell indexPath:indexPath];
    return cell;
}
-(void)setupCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    NSString *cellCalssName = [[_list objectAtIndex:indexPath.section][@"list"] objectAtIndex:indexPath.row][@"cell"];
    NSArray *items = [_list objectAtIndex:indexPath.section][@"list"];
    id item = [items objectAtIndex:indexPath.row];
    if ([cellCalssName isEqualToString:@"EditTextCell"]){
        textfield_count = [[_list objectAtIndex:indexPath.section][@"count"] intValue];
        
        //NSLog(@"%@",item);
        EditTextCell *aCell =(EditTextCell *)cell;
        aCell.keyLabel.text = item[@"label"];
        aCell.key = item[@"key"];
        aCell.valueText.text = item[@"value"];
        aCell.valueText.delegate = self;
        aCell.valueText.tag = indexPath.row;
        aCell.valueText.placeholder = item[@"placeholder"];
        aCell.valueText.autocapitalizationType = UITextAutocapitalizationTypeNone;
        aCell.valueText.secureTextEntry =NO;
        aCell.targetObject = item;
        if ([item[@"ispassword"] isEqualToString:@"yes"]){
            aCell.valueText.secureTextEntry=YES;
        }else if ([item[@"ispassword"] isEqualToString:@"number"]){
            aCell.valueText.keyboardType = UIKeyboardTypeNumberPad;
        }else if ([item[@"ispassword"] isEqualToString:@"decimal"]){
            aCell.valueText.keyboardType = UIKeyboardTypeDecimalPad;
        }else if ([item[@"ispassword"] isEqualToString:@"capital"]){
            aCell.valueText.keyboardType = UIKeyboardAppearanceDefault;
            aCell.valueText.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        }
        if (indexPath.row <textfield_count-1){
            aCell.valueText.returnKeyType = UIReturnKeyNext;
        }else{
            aCell.valueText.returnKeyType = UIReturnKeyGo;
        }
        id input_disable = item[@"disable"];
        if (input_disable){
            aCell.valueText.enabled = NO;
            aCell.valueText.borderStyle =UITextBorderStyleNone;
        }else{
            [aCell.valueText addTarget:aCell action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
            [aCell.valueText addTarget:aCell action:@selector(onExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
            aCell.delegate = self;
        }
        if (item[@"has_choice"]){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else if ([cellCalssName isEqualToString:@"OneButtonCell"]){
        OneButtonCell *aCell =(OneButtonCell *)cell;
        aCell.button.text = item[@"label"];
        aCell.delegate = self;
        aCell.targetObject = item;
        aCell.tag =indexPath.row;
        if ([@"0" isEqualToString:item[@"default"]]){
            [aCell setupButtonWithType:0];
        }
    }else if ([cellCalssName isEqualToString:@"SwitchCell"]){
        
        NSLog(@"%@",item);
        SwitchCell *aCell = (SwitchCell *)cell;
        aCell.lblTitle.text = item[@"label"];
        aCell.delegate = self;
        aCell.targetObject = item;
        [aCell.switchResult setOn:[@"1" isEqualToString:item[@"value"]]];
        
        
    }else if ([cellCalssName isEqualToString:@"ChooseNextCell"]){
       
        ChooseNextCell *aCell = (ChooseNextCell *)cell;
        aCell.lblTitle.text = item[@"label"];
        aCell.lblDescription.text = item[@"value"];
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSString *icon = item[@"icon"];
        if (icon && ![icon isEqualToString:@""]){
            cell.imageView.image = [UIImage imageNamed:icon];
        }
    }else if ([cellCalssName isEqualToString:@"ChooseNextImageCell"]){
        
        ChooseNextImageCell *aCell = (ChooseNextImageCell *)cell;
        aCell.lblTitle.text = item[@"label"];
        aCell.lblDescription.text = item[@"value"];
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSString *icon = item[@"icon"];
        if (icon && ![icon isEqualToString:@""]){
            aCell.imageIcon.image = [UIImage imageNamed:icon];
        }
    }else if ([cellCalssName isEqualToString:@"TextLabelCell"]){
        TextLabelCell *aCell = (TextLabelCell *)cell;
        aCell.text.text = item[@"label"];
    }else if ([cellCalssName isEqualToString:@"default"]){
        cell.textLabel.text = item[@"label"];
        cell.detailTextLabel.text = item[@"value"];
    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item  = [[_list objectAtIndex:indexPath.section][@"list"] objectAtIndex:indexPath.row];
    if ([item[@"cell"] isEqualToString:@"ChooseNextCell"]){
        NSString *vcname = item[@"placeholder"];
        NSString *value = item[@"value"];
        if ([vcname isEqualToString:@"DatePickerViewController"]){
            DatePickerViewController *vc = [[DatePickerViewController alloc] initWithNibName:@"DatePickerViewController" bundle:nil];
            vc.keyname = item[@"key"];//@"init_date";
            vc.delegate = self;
            
            [self.navigationController pushViewController:vc animated:YES];
            if (value && ![value isEqualToString:@""])
            {
                vc.value = value;
            }
        }else{
            LicenseTypeViewController *vc = [[LicenseTypeViewController alloc] initWithNibName:@"LicenseTypeViewController" bundle:nil];
            vc.delegate = self;
            
            [self.navigationController pushViewController:vc animated:YES];
            vc.value = value;
        }
    }
    [self performSelector:@selector(delectCell:) withObject:nil afterDelay:0.2];
}
-(void)setValueByKey:(NSString *)value key:(NSString *)key{

    for (id tempList in _list) {
        for (id item in tempList[@"list"]) {
            if ([item[@"key"] isEqual:key]){
                item[@"value"]=value;
            }
        }
    }
    [self.tableView reloadData];
}
-(void)tapOn:(UITapGestureRecognizer *)recognizer{
    if (_lastTextField){
        [_lastTextField resignFirstResponder];
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _lastTextField =textField;
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
   
    if (textField.tag==textfield_count-1){
        [self done];
    }else{
        [self setResponser:textField.tag+1];
    }
    return YES;
}
-(void)setResponser:(int)tag{
    for (UIView *v in [self.tableView subviews]) {
        if ([v isKindOfClass:[EditTextCell class]]){
            EditTextCell *cell = (EditTextCell *)v;
            if (cell.valueText.tag==tag){
                [cell.valueText becomeFirstResponder];
            }
        }
        
    }
}
-(void)done{
    NSMutableDictionary *_result =[[NSMutableDictionary alloc] init];
    /*
    for (UIView *v in [self.tableView subviews]) {
        if ([v isKindOfClass:[EditTextCell class]]){
            EditTextCell *cell = (EditTextCell *)v;
            [_result setObject:cell.valueText.text forKey:cell.key];
        }else if ([v isKindOfClass:[SwitchCell class]]){
            SwitchCell *cell = (SwitchCell *)v;
            [_result setObject:cell.targetObject[@"value"] forKey:cell.targetObject[@"key"]];
        }
        
    }*/
    for(id temp in _list){
        for(id item in temp[@"list"]){
            if (item && item[@"key"] && item[@"value"]){
                [_result setObject:item[@"value"] forKey:item[@"key"]];
            }
        }
    }
    NSLog(@"%@",_result);
    [self processSaving:_result];
    
}
-(void)processSaving:(NSMutableDictionary *)parameters{
    
}
-(void)buttonPress:(OneButtonCell *)sender{
    NSLog(@"%@",sender);
    
}


-(void)delectCell:(id)sender{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

-(void)switchChanged:(UISwitch *)aSwitch cell:(SwitchCell *)cell{
    if (cell.targetObject){
        NSLog(@"%@",cell.targetObject);
        cell.targetObject[@"value"] = aSwitch.on?@"1":@"0";
    }
}
-(void)valueChanged:(NSString *)key value:(NSString *)value{

}
-(void)exitEdit:(NSString *)key value:(NSString *)value{
    NSLog(@"%@=%@",key,value);
}
@end
