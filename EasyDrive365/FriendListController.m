//
//  FriendListController.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/20/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "FriendListController.h"
#import "AppSettings.h"
#import "FriendHeader.h"
#import "FriendListCell.h"

@interface FriendListController (){
    id _list;
    NSString *_content;
    FriendHeader *_header;
    NSString *_invite_code;
    NSString *_share_title;
    NSString *_share_inctroduce;
    NSString *_share_url;
    BOOL _is_can_invite;
    NSString *_input_code;
}

@end

@implementation FriendListController

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
    self.title = @"邀请朋友";
    [self load_data];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleBordered target:self action:@selector(share)];
    
}
-(void)share{
    [[AppSettings sharedSettings] popupShareMenu:_share_title introduce:_share_inctroduce url:_share_url];
}
-(void)load_data{
    NSString *url;
    if (self.taskid>0) {
        url = [NSString stringWithFormat:@"bound/get_my_friends?userid=%d&taskid=%d",[AppSettings sharedSettings].userid,self.taskid];
    }else{
        url = [NSString stringWithFormat:@"bound/get_my_friends?userid=%d",[AppSettings sharedSettings].userid];
    }
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _list =json[@"result"][@"friends"];
            NSLog(@"%@",_list);
            _content = json[@"result"][@"content"];
            _invite_code = json[@"result"][@"invite_code"];
            _share_url = json[@"result"][@"share_url"];
            _share_title = json[@"result"][@"share_title"];
            _share_inctroduce = json[@"result"][@"share_intro"];
            _is_can_invite = [json[@"result"][@"is_can_invite"] intValue] ==1;
            [self.tableView reloadData];
            
            
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
    return [_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell==nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendListCell" owner:nil options:nil] objectAtIndex:0];
    }
    id item = [_list objectAtIndex:indexPath.row];
    NSLog(@"%@",item);
    FriendListCell *aCell = (FriendListCell *)cell;
    aCell.lblName.text = item[@"name"];
    aCell.lblDate.text = [AppSettings getStringDefault:item[@"registerDate"] default:@""];
    aCell.lblMemo.text = item[@"is_bounds"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0){
        return 120.0f;
    }
    return  0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0){
        if (!_header){
            _header =[[[NSBundle mainBundle] loadNibNamed:@"FriendHeader" owner:nil options:nil] objectAtIndex:0];
          
            _header.parent = self.navigationController;
            [_header.btnSave addTarget:self action:@selector(saveInviteCode) forControlEvents:UIControlEventTouchUpInside];
        }
        _header.lblContent.text= _content;
        _header.lblInvite_code.text =@"";// _invite_code;
        [_header.txtInviteCode setEnabled:_is_can_invite];
        [_header.btnSave setEnabled:_is_can_invite];
        if (![_invite_code isEqualToString:@""]){
             _header.txtInviteCode.text =_invite_code;
        }
        return _header;
    }
    return nil;
}

-(void)saveInviteCode{
    NSLog(@"%@",_header.txtInviteCode.text);
    _input_code = _header.txtInviteCode.text;
    if (![_header.txtInviteCode.text isEqualToString:@""]){
        NSString *url = [NSString stringWithFormat:@"bound/update_invite?userid=%d&code=%@",[AppSettings sharedSettings].userid,_header.txtInviteCode.text];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                _is_can_invite =NO;
                _list =json[@"result"][@"friends"];
                [self.tableView reloadData];
                _header.txtInviteCode.text = _input_code;
                [_header.txtInviteCode setEnabled:_is_can_invite];
                [_header.btnSave setEnabled:_is_can_invite];
                [self load_data];
            }
        }];
    }
}

@end
