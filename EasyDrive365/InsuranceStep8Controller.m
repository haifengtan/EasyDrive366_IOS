//
//  InsuranceStep8Controller.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/27/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "InsuranceStep8Controller.h"
#import "UIImageView+AFNetworking.h"
#import "AppSettings.h"
#import "Browser2Controller.h"
#import "SVProgressHUD.h"
#import "AFHTTPClient.h"
@interface InsuranceStep8Controller ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIImageView *_imageView;
    id _currentAction;
    UIImage *_image;
}

@end

@implementation InsuranceStep8Controller

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

    self.title = @"照片上传";
 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(finishAll)];
}
-(void)finishAll{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0){
        return [self.upload_data[@"action"] count];
    }else{
        return [self.upload_data[@"help"] count];
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0){
        return @"照片";
    }else{
        return @"说明";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if (indexPath.section==0){
        id item = [self.upload_data[@"action"] objectAtIndex:indexPath.row];
        cell.textLabel.text = item[@"title"];
        UIImageView *imageCell= [[UIImageView alloc] initWithFrame:CGRectMake(240, 2, 40, 40)];
        imageCell.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImage:)];
        imageCell.userInteractionEnabled = YES;
        imageCell.tag = [item[@"id"] intValue]; //indexPath.row;
        
        [imageCell addGestureRecognizer:tap];
    
        [imageCell removeFromSuperview];
        /*
        if (indexPath.row==0){
            item[@"photourl"]=@"http://e.hiphotos.baidu.com/image/w%3D2048/sign=6c91e31feb24b899de3c7e385a3e1c95/730e0cf3d7ca7bcb4eef0e30bc096b63f624a81d.jpg";
        }else if (indexPath.row==1){
            item[@"photourl"]=@"http://h.hiphotos.baidu.com/image/w%3D2048/sign=443597d217ce36d3a20484300ecb3b87/3801213fb80e7bec4b6768e92d2eb9389b506b7c.jpg";
        }
         */
        if ([item[@"photourl"] hasPrefix:@"http://"]){
            [imageCell setImageWithURLWithoutCache:[NSURL URLWithString:item[@"photourl"]] placeholderImage:Nil];
            //[imageCell setImageWithURL:[NSURL URLWithString:item[@"photourl"]]];
        }else{
            imageCell.image = [UIImage imageNamed:item[@"photourl"]];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell addSubview:imageCell];
    }else{
        id item = [self.upload_data[@"help"] objectAtIndex:indexPath.row];
        cell.textLabel.text = item[@"title"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(void)tapOnImage:(UITapGestureRecognizer *)sender{
    NSLog(@"%d",sender.view.tag);
    [self load_origin_image:sender.view.tag];
}
-(void)load_origin_image:(int)typeid{
    NSString *url = [NSString stringWithFormat:@"ins/carins_get_photo?userid=%d&typeid=%d",[AppSettings sharedSettings].userid,typeid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            [self showBigImage:json[@"result"]];
        }
    }];
}
-(void)showBigImage:(NSString *)url{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 300, 300)];
    _imageView.contentMode = UIViewContentModeCenter;
    if ([url hasPrefix:@"http://"]){
        [_imageView setImageWithURLWithoutCache:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"m"]];
    }else{
        _imageView.image = [UIImage imageNamed:url];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnBigImage)];
    [_imageView addGestureRecognizer:tap];
    _imageView.userInteractionEnabled = YES;
    [_imageView removeFromSuperview];
    [self.view addSubview:_imageView];
}
-(void)tapOnBigImage{
    [_imageView removeFromSuperview];
    _imageView = nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0){
        _currentAction =[self.upload_data[@"action"] objectAtIndex:indexPath.row];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        [actionSheet showInView:self.view];
        
    }else if (indexPath.section==1){
        id item = [self.upload_data[@"help"] objectAtIndex:indexPath.row];
        Browser2Controller *vc = [[Browser2Controller alloc] initWithNibName:@"Browser2Controller" bundle:nil];
        vc.url = item[@"url"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self pickImage:UIImagePickerControllerSourceTypeCamera];
    }else if(buttonIndex ==1){
        [self pickImage:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}
- (UIImage *)scaleImage:(UIImage *) image maxWidth:(float) maxWidth maxHeight:(float) maxHeight
{
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    if (width <= maxWidth && height <= maxHeight)
    {
        return image;
    }
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > maxWidth || height > maxHeight)
    {
        CGFloat ratio = width/height;
        if (ratio > 1)
        {
            bounds.size.width = maxWidth;
            bounds.size.height = bounds.size.width / ratio;
        }
        else
        {
            bounds.size.height = maxHeight;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    CGFloat scaleRatio = bounds.size.width / width;
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    CGContextTranslateCTM(context, 0, -height);
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    if (!error){
        UIAlertView *av=[[UIAlertView alloc] initWithTitle:nil message:@"Image written to photo album"delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [av show];
    }else{
        UIAlertView *av=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Error writing to photo album: %@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [av show];
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _image =[info valueForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //[self saveImage:[self scaleToSize:_image size:CGSizeMake(600, 600)]];
    [self saveImage:[self scaleImage:_image maxWidth:640 maxHeight:960]];
}

- (void) pickImage:(UIImagePickerControllerSourceType )sourceType
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = sourceType;
    ipc.delegate =self;
    ipc.allowsEditing =NO;
    [self presentViewController:ipc animated:YES completion:nil];
    
    
}
-(void)saveImage:(UIImage *)image
{
    if (!_currentAction)
        return;
    NSString *url =[NSString stringWithFormat:@"upload/upload_carins"];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:SERVERURL]];
    NSURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:url parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
        NSString *filename = [NSString stringWithFormat:@"upload.png"];
        [formData appendPartWithFileData:imageData name:@"userfile" fileName:filename mimeType:@"image/png"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%d",[AppSettings sharedSettings].userid] dataUsingEncoding:NSUTF8StringEncoding]  name:@"userid"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",_currentAction[@"id"]] dataUsingEncoding:NSUTF8StringEncoding]  name:@"typeid"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"iphone"] dataUsingEncoding:NSUTF8StringEncoding]  name:@"from"];
        
        
        
    }];
    AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        id jsonResult =[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"%@",jsonResult);
        if ([[AppSettings sharedSettings] isSuccess:jsonResult]){
            //[_imageCell setImageWithURL:[NSURL URLWithString:jsonResult[@"result"]] placeholderImage:[UIImage imageNamed:@"m"]];
            //[[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_USER_PROFILE object:nil];
            //_user[@"photourl"]=jsonResult[@"result"];
            _currentAction[@"photourl"]=jsonResult[@"result"];
            [self.tableView reloadData];
        }
        if (![[jsonResult objectForKey:@"status"] isEqualToString:@"success"]){
            NSString *message = @"发生异常，请稍后再试.";
            if ([[jsonResult allKeys] containsObject:@"message"]){
                message = [jsonResult objectForKey:@"message"];
            }
            [SVProgressHUD dismissWithSuccess:message afterDelay:3];
        }else{
            id alertMsg = jsonResult[@"alertmsg"];
            if (alertMsg && ![alertMsg isKindOfClass:[NSNull class]] && ![alertMsg isEqualToString:@""]){
                [SVProgressHUD dismissWithSuccess:alertMsg afterDelay:3];
            }else{
                [SVProgressHUD dismissWithSuccess:@"图片上传成功！" afterDelay:3];
            }
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Access server error:%@,because %@",error,operation.request);
        
        
    }];
    [SVProgressHUD showWithStatus:@"正在上传图片..."];
    NSOperationQueue *queue=[[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
}
@end
